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

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

class SignInWithGoogle {
    
    @MainActor
    func signInWithGoogle() async throws -> GoogleSignInResultModel {
        guard let clientID = FirebaseApp.app()?.options.clientID else {throw URLError(.cannotFindHost)}
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let googleSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: ApplicationUtility.rootViewController)
        
        let user = googleSignInResult.user
        guard let idToken = user.idToken?.tokenString else {throw URLError(.badServerResponse)}
        let acessToken = user.accessToken.tokenString
        let name = user.profile?.name ?? ""
        let email  = user.profile?.email
    
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: acessToken, name: name, email: email)
        return tokens
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

