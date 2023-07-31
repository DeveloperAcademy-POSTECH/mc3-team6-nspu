//
//  FirebaseManager.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/17.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

enum SignUpState {
    case beforeSignUp
    case duringSignUp
    case afterSignUp
}

class FirebaseManager: ObservableObject {
    
    private var db = Firestore.firestore()
    //    private var user: UserInfo?
    @Published var signUpState = SignUpState.beforeSignUp
    private lazy var refUserInfo = db.collection("UserInfo")
    
    // TODO: 현재 사용하지 않음 - 삭제 예정?
    /// 유저 데이터를 불러옵니다.
    func fetchUserInfo() async throws {
        guard let userId = getCurrentUserId() else {
            print("fetchUserInfo: 유저 없다")
            return
        }
        
        let documentSnapshot = try await refUserInfo.document(userId).getDocument()
        
        User.instance.userInfo = try documentSnapshot.data(as: UserInfo.self)
    }
    
    /// 현재 유저의 uid를 가져옵니다.
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    /// FIrebase 로그아웃 기능입니다.
    func logOut(){
        do {
            try Auth.auth().signOut()
            //            self.user = nil
            User.instance.userInfo = nil
            self.signUpState = .beforeSignUp
            UserDefaults.standard.removeObject(forKey: "userId")
            
        } catch {
            print(error)
        }
    }
}


// MARK: - LogIn
extension FirebaseManager {
    
    /// 애플 로그인을 실행합니다.
    func signInApple() async throws {
        let helper = SignInWithApple()
        let tokens = try await helper.startSignInWithAppleFlow()
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokens.token, rawNonce: tokens.nonce)
        try await self.signIn(credential: credential)
    }
    
    /// 구글 로그인을 실행합니다.
    func singInGoogle() async throws {
        let helper = SignInWithGoogle()
        let tokens = try await helper.signInWithGoogle()
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
        try await self.signIn(credential: credential)
    }
    
    /// 구글, 애플 로그인 인증서(credential)를 바탕으로 Firebase에 SignIn합니다.
    /// Parameter credential: 각 로그인 함수에서의 AuthCredential
    @MainActor
    func signIn(credential: AuthCredential) async throws {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        // authResultUser : SignIn Result User
        let authResultUser = authDataResult.user
        // DbUser : DB에 저장되어있는 유저
        let DbUser = try await getUser(userId: authResultUser.uid)
        if DbUser == nil {
            //            self.user = UserInfo(id: authResultUser.uid, name: authResultUser.displayName ?? "", email: authResultUser.email ?? "", nickName: "")
            User.instance.userInfo = UserInfo(id: authResultUser.uid, name: authResultUser.displayName ?? "", email: authResultUser.email ?? "", nickName: "")
            self.signUpState = .duringSignUp
        }
        // 이미 회원가입이 되어있는 유저의 로그인
        else {
            UserDefaults.standard.set(authResultUser.uid, forKey: "userId")
//            UserDefaults.standard.set(Date(), forKey: "lastVisitDate")
            UserDefaults.standard.set(0, forKey: "focusedStageIndex")
            // 로그인 시에 가장 최근 유저플로어 데이터 가져와서 유저디폴트에 저장
            guard let DbUserFloor = try await self.readRecentUserFloor() else {return}
            self.saveDataToUserDefaults(DbUserFloor)
    
            self.signUpState = .afterSignUp
        }
    }
    
    func saveDataToUserDefaults(_ userFloor: UserFloor) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userFloor){
            UserDefaults.standard.set(encoded, forKey: "userFloor")
        }
    }
    
    /// Firebase의 firestore DB에 유저를 등록시킵니다. (닉네임 입력후 회원가입 완료할 때 사용)
    /// Parameter result: signInToFirebase 함수의 result
    @MainActor
    func createUser(_ nickName: String) async throws {

        if let userId = User.instance.userInfo?.id {
            let now = Date()
            User.instance.userInfo?.nickName = nickName
            User.instance.userInfo?.createdAt = now
            User.instance.userInfo?.lastVisitDate = now
            try await refUserInfo.document(userId).setData([
                "id": userId,
                "name": User.instance.userInfo?.name ?? "error",
                "email": User.instance.userInfo?.email ?? "error",
                "nickName": nickName,
                "lastVisitDate": now,
                "createdAt": now
            ])
            
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.set(0, forKey: "focusedStageIndex")
            // 회원가입시, 서버에 처음 유저플로어 데이터 입력.
//            guard let fivedaysago = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {return}
            let userFloor = UserFloor(dailyFloors: 0, totalFloors: 0, date: now)
            self.createUserFloor(userFloor: userFloor)
            
            // 유저디폴트에 floors 입력
            guard let userFloorFromDB = try await self.readRecentUserFloor() else {return}
            self.saveDataToUserDefaults(userFloorFromDB)
            
            self.createUserStage()
            self.signUpState = .afterSignUp
        }
    }
    
    /// DB에 저장되어 있는 userId를 가진 유저 데이터를 반환합니다. ( 이미 회원가입을 한 유저인지 판별하기 위해 사용)
    func getUser(userId: String) async throws -> UserInfo? {
        //        let userCollection = db.collection("User")
        let docRef = refUserInfo.document(userId)
        
        var result: UserInfo? = nil
        
        do {
            let document = try await docRef.getDocument(as: UserInfo.self)
            result = document
        } catch {
            result = nil
        }
        
        return result
    }
}



// MARK: - Floor data 계산 CRUD
extension FirebaseManager {
    /// Create userFloor: UserFloor row를 db에 생성합니다.
    /// Parameter userFloor: UserFloor 모델 객체
    func createUserFloor(userFloor: UserFloor) {
        if let userId = self.getCurrentUserId(){
            do {
                try refUserInfo.document(userId).collection("UserFloor").document().setData(from: userFloor)
            }
            catch {
                print(error)
            }
        }
    }
    
    /// Read userFloor
    /// 가장 최근의 UserFloor 데이터를 가져옵니다.
    func readRecentUserFloor() async throws -> UserFloor? {
        guard let userId = self.getCurrentUserId() else {return nil}
        
        let querySnapshot = try await refUserInfo.document(userId).collection("UserFloor").order(by: "date", descending: true).limit(to:5).getDocuments()
        guard let firstDocument = querySnapshot.documents.first else {return nil}
        let documentId = firstDocument.documentID
        var userFloor = try firstDocument.data(as: UserFloor.self)
        userFloor.id = documentId

        print("최근 유저층수 문서id: \(userFloor.id ?? "")")
        
        return userFloor
    }
    
    /// DB의 UserFloor 데이터를 업데이트 합니다.
    func updateUserFloor(oldData: UserFloor ,newData: UserFloor) async throws {
        guard let userId = getCurrentUserId() else {return}
        
//        let userFloor = try await self.readRecentUserFloor()
        guard let userFloorId = oldData.id else {return}
        
        try await self.refUserInfo.document(userId).collection("UserFloor").document(userFloorId).updateData([
            "dailyFloors" : newData.dailyFloors,
            "totalFloors" : newData.totalFloors,
            "date" : newData.date
        ])
    }
}


// MARK: - Stage
extension FirebaseManager {
    /// UserStage를 데이터베이스에 생성합니다. (회원가입시 처음에만 생성할 예정)
    func createUserStage() {
        let userStage = UserStage(currentStage: 0, currentStageFloors: 0)
        guard let userId = self.getCurrentUserId() else {return}
        do {
            try refUserInfo.document(userId).collection("UserStage").document().setData(from: userStage)
        }
        catch {
            print(error)
        }
    }
    
    /// UserStage를 데이터베이스에서 불러와 리턴합니다.
    func readUserStage() async throws -> UserStage?{
        guard let userId = self.getCurrentUserId() else {return nil}
        
        let querySnapshot = try await refUserInfo.document(userId).collection("UserStage").getDocuments()
        guard let document = querySnapshot.documents.first else {return nil}
        let documentId = document.documentID
        var userStage = try document.data(as: UserStage.self)
        userStage.id = documentId
        
        return userStage
    }
    
    /// newData 값으로 데이터베이스의 데이터를 업데이트 합니다.
    func updateUserStage(_ newData: UserStage) async throws {
        guard let userId = self.getCurrentUserId() else {return}
        let oldData = try await self.readUserStage()
        guard let documentId = oldData?.id else {return}
        
        try await self.refUserInfo.document(userId).collection("UserStage").document(documentId).updateData([
            "currentStage" : newData.currentStage,
            "currentStageFloors": newData.currentStageFloors,
        ])
    }
}

