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
                self.user = User(id: resultUser.uid, name: userName, email: resultUser.email ?? "", nickName: "", lastVisitDate: Date(), createdAt: Date())
                print(self.user)
            }
        }
    }
    
    /// Firebase의 firestore DB에 유저를 등록시킵니다.
    /// Parameter result: signInToFirebase 함수의 result
    func createUser(){
        print("New User Create")
        
        if let userId = user?.id {
            db.collection("User").document(userId).setData([
                "name": user?.name ?? "error",
                "email": user?.email ?? "error",
                "nickName": "아직 미정",
                "lastVisitDate": Date(),
                "createdAt": Date()
            ])
        }
        
        // TODO: User Default 추가
    }
    
    /// 현재 유저의 uid를 가져옵니다.
    func getCurrentUserId() -> String?{
        return Auth.auth().currentUser?.uid
    }
    
    /// FIrebase 로그아웃 기능입니다.
    func logOut(){
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print(error)
        }
    }
}
