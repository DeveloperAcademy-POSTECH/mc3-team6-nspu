//
//  SignInWithGoogle.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/16.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInWithGoogle: ObservableObject {
    @Published var isLoginSuccessed = false
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController) {user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard
                let user = user?.user,
                let idToken = user.idToken else {return}
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            let name = user.profile?.name ?? ""
            
            FirebaseManager.instance.signInToFirebase(credential: credential, userName: name)
        }
    }
}


final class ApplicationUtility {
        static var rootViewController: UIViewController {
    
            guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return .init()
            }
    
            guard let root = screen.windows.first?.rootViewController else {
                return .init()
            }
    
            return root
        }
}

