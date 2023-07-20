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
    
    @MainActor
    func signInWithGoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {return}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        
        let googleSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController)
        
        let user = googleSignInResult.user
        guard let idToken = user.idToken else {return}
        let acessToken = user.accessToken
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString , accessToken: acessToken.tokenString)
        
        let name = user.profile?.name ?? ""
        
        try await FirebaseManager.instance.signInToFirebase(credential: credential, userName: name)   
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

