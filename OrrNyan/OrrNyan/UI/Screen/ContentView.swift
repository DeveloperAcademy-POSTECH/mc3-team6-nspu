//
//  ContentView.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/12.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @AppStorage("userId") var userId: String?

    var body: some View {
        VStack{
            switch firebaseManager.signUpState {
            case .beforeSignUp:
                LoginView()
            case .duringSignUp:
                CreateNameView()
            case .afterSignUp:
                StageView()
            }
        }
        .onAppear{
            if userId != nil {
                firebaseManager.signUpState = .afterSignUp
            }
            else {
                firebaseManager.signUpState = .beforeSignUp
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
