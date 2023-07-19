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
    func signInToFirebase(credential: AuthCredential, userName: String) async throws {
        let signInResult = try await Auth.auth().signIn(with: credential)
        let resultUser = signInResult.user
        if self.user == nil {
            self.user = User(id: resultUser.uid, name: userName, email: resultUser.email ?? "", nickName: "")
        }
    }
    
    /// Firebase의 firestore DB에 유저를 등록시킵니다.
    /// Parameter result: signInToFirebase 함수의 result
    func createUser(_ nickName: String) async throws {
        print("New User Create")
        
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
        }
    }
    
    /// 유저 데이터를 불러옵니다.
    func readUserData() async throws {
//        guard let userid2 = UserDefaults.standard.string(forKey: "userId") else {return}
        guard let userId = getCurrentUserId() else {return}
        
        let documentSnapshot = try await db.collection("User").document(userId).getDocument()
        
        let user = try documentSnapshot.data(as: User.self)
        print("이거지이 \(user)")
        
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
//        db.collection("User").document(userId).getDocument { document, error in
//            if let error {
//                print(error.localizedDescription)
//            }
//            else {
//                if let document {
//                    do {
//                        let user = try document.data(as: User.self)
//                        // TODO: - User 모델로 반환
//                        print("이거다아아 \(user)")
//                    }
//                    catch {
//                        print(error)
//                    }
//                }
//            }
//        }
        
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


// MARK: - Floor data 계산 CRUD
extension FirebaseManager {
    /// Create userFloor
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
        
        
//        db.collection("User").document(userId).collection("UserFloor").order(by: "date", descending: true).limit(to:5).getDocuments(completion: { querySnapshot, error in
//            if let error {
//                print(error)
//                return
//            } else {
//                do {
//                    userFloor = try querySnapshot!.documents[0].data(as: UserFloor.self)
//
//                    print(userFloor?.id ?? "")
//                } catch {
//                    print(error)
//                }
//            }
//
//        })
        
        
        
    }
    
    /// Update userFloor
    func updateUserFloor() async throws {
        guard let userId = getCurrentUserId() else {return}//UserDefaults.standard.string(forKey: "userID") else {return}
        
        let userFloor = try await self.readUserFloor()
        guard let userFloorId = userFloor?.id else {return}
        
        try await self.db.collection("User").document(userId).collection("UserFloor").document(userFloorId).updateData([
            "dailyFloors" : 1,
            "totalFloors" : 1,
            "date" : Date()
        ])
        /*
        do {
            db.collection("User").document(userId).collection("UserFloor").order(by: "date", descending: true).limit(to: 5).getDocuments(completion: { querySnapshot, error in
                if let error {
                    print(error)
                    return
                }
                
                else {
                    do {
                        let userFloor = try querySnapshot!.documents[0].data(as: UserFloor.self)
                        print(userFloor.id ?? "")
                        userFloorId = userFloor.id ?? ""
                        
                        // MARK: 업데이트 코드
                        self.db.collection("User").document(userId).collection("UserFloor").document(userFloorId).updateData([
                            "dailyFloors" : 1,
                            "totalFloors" : 1,
                            "date" : Date()
                        ])
                    } catch {
                        print(error)
                    }
                }
            })
        }
        catch {
            print(error.localizedDescription)
        }
*/
    }
}
