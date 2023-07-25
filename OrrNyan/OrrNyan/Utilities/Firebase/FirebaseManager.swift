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
    private var user: User?
    @Published var signUpState = SignUpState.beforeSignUp
    
    // TODO: 현재 사용하지 않음 - 삭제 예정?
    /// 유저 데이터를 불러옵니다.
    func readUserData() async throws {
        guard let userId = getCurrentUserId() else {return}
        
        let documentSnapshot = try await db.collection("User").document(userId).getDocument()
        
        let user = try documentSnapshot.data(as: User.self)
    }
    
    /// 현재 유저의 uid를 가져옵니다.
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    /// FIrebase 로그아웃 기능입니다.
    func logOut(){
        do {
            try Auth.auth().signOut()
            self.user = nil
            self.signUpState = .beforeSignUp
            UserDefaults.standard.removeObject(forKey: "userId")
            
        } catch {
            print(error)
        }
    }
}

// MARK: - Floor data 계산 CRUD
extension FirebaseManager {
    /// Create userFloor: UserFloor row를 db에 생성합니다.
    /// Parameter userFloor: UserFloor 모델 객체
    func createUserFloor(userFloor: UserFloor) {
        if let userId = self.getCurrentUserId(){
            do {
                try db.collection("User").document(userId).collection("UserFloor").document().setData(from: userFloor)
            }
            catch {
                print(error)
            }
        }
    }
    
    /// Read userFloor
    /// 가장 최근의 UserFloor 데이터를 가져옵니다.
    func readUserFloor() async throws -> UserFloor? {
        guard let userId = self.getCurrentUserId() else {return nil}
        
        let te = try await db.collection("User").document(userId).collection("UserFloor").order(by: "date", descending: true).limit(to:5).getDocuments()
        let userFloor = try te.documents[0].data(as: UserFloor.self)
        
        print("최근 유저층수 문서id: \(userFloor.id ?? "")")
        
        return userFloor
    }
    
    /// DB의 UserFloor 데이터를 업데이트 합니다.
    func updateUserFloor() async throws {
        guard let userId = getCurrentUserId() else {return}
        
        let userFloor = try await self.readUserFloor()
        guard let userFloorId = userFloor?.id else {return}
        
        try await self.db.collection("User").document(userId).collection("UserFloor").document(userFloorId).updateData([
            "dailyFloors" : 1,
            "totalFloors" : 1,
            "date" : Date()
        ])
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
            self.user = User(id: authResultUser.uid, name: authResultUser.displayName ?? "", email: authResultUser.email ?? "", nickName: "")
            self.signUpState = .duringSignUp
        }
        else {
            UserDefaults.standard.set(authResultUser.uid, forKey: "userId")
            UserDefaults.standard.set(Date(), forKey: "lastVisitDate")
            self.signUpState = .afterSignUp
        }
    }
    
    /// Firebase의 firestore DB에 유저를 등록시킵니다. (닉네임 입력후 회원가입 완료할 때 사용)
    /// Parameter result: signInToFirebase 함수의 result
    @MainActor
    func createUser(_ nickName: String) async throws {
        
        if let userId = user?.id {
            try await db.collection("User").document(userId).setData([
                "id": userId,
                "name": user?.name ?? "error",
                "email": user?.email ?? "error",
                "nickName": nickName,
                "lastVisitDate": Date(),
                "createdAt": Date()
            ])

            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.set(user?.lastVisitDate, forKey: "lastVisitDate")
            self.signUpState = .afterSignUp
            print("New User Create")
        }
    }
    
    /// DB에 저장되어 있는 userId를 가진 유저 데이터를 반환합니다. ( 이미 회원가입을 한 유저인지 판별하기 위해 사용)
    func getUser(userId: String) async throws -> User? {
        let userCollection = db.collection("User")
        let docRef = userCollection.document(userId)
    
        var result: User? = nil
        
        do {
            let document = try await docRef.getDocument(as: User.self)
            result = document
        } catch {
            result = nil
        }
        
        return result
    }
}
