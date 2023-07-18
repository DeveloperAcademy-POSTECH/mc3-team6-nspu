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

class FirebaseManager {

    static let instance = FirebaseManager()
    private var db = Firestore.firestore()
    private var user: User?
    
    /// 구글, 애플 로그인 할 때 불리는 함수입니다.
    /// Parameter credential: 각 로그인 함수에서의 AuthCredential
    func signInToFirebase(credential: AuthCredential, userName: String) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error {
                print(error.localizedDescription)
            }
            
            guard let resultUser = result?.user else {return}
            
            if self.user == nil {
                self.user = User(id: resultUser.uid, name: userName, email: resultUser.email ?? "", nickName: "")
            }
        }
    }
    
    /// Firebase의 firestore DB에 유저를 등록시킵니다.
    /// Parameter result: signInToFirebase 함수의 result
    func createUser(_ nickName: String){
        print("New User Create")
        
        if let userId = user?.id {
            db.collection("User").document(userId).setData([
                "id": userId,
                "name": user?.name ?? "error",
                "email": user?.email ?? "error",
                "nickName": nickName,
                "lastVisitDate": Date(),
                "createdAt": Date()
            ])
            
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.set(user?.lastVisitDate, forKey: "lastVisitDate")
        }
    }
    
    /// 유저 데이터를 불러옵니다.
    func readUserData(){
        guard let userId = getCurrentUserId() else {return}
// TODO: 주석 제거 (데이터 read 예시 코드)
/*        db.collection("User").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print(dataDescription)
                
                let name = document.get("name") as? String
                let email = document.get("email") as? String
                let nickName = document.get("nickName") as? String
                let lastVisitStamp = document.get("lastVisitDate") as? Timestamp
                let lastVisitDate = lastVisitStamp?.dateValue()
                let createdAtStamp = document.get("createdAt") as? Timestamp
                let createdAt = createdAtStamp?.dateValue()
                print("\(name), \(email), \(nickName), \(lastVisitDate), \(createdAt)")
            }
        }
*/
        db.collection("User").document(userId).getDocument { document, error in
            if let error {
                print(error.localizedDescription)
            }
            else {
                if let document {
                    do {
                        let user = try document.data(as: User.self)
                        // TODO: - User 모델로 반환
                        print("이거다아아 \(user)")
                    }
                    catch {
                        print(error)
                    }
                }
            }
        }
        
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
            UserDefaults.standard.removeObject(forKey: "userId")
        } catch {
            print(error)
        }
    }
}


// MARK: - Floor data 계산
extension FirebaseManager {
    /// Write userFloor
    func writeUserFloor(userFloor: UserFloor) {
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
    
    
    /// Update userFloor
}
