//
//  LoginView.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/16.
//

import SwiftUI

struct LoginView: View {
    @StateObject var vm = SignInWithGoogle()
    
    var body: some View {
        VStack{
            Button {
                vm.signInWithGoogle()
            } label: {
                Text("로그인 버튼")
            }
            
            Button {
                SignInWithApple.instance.startSignInWithAppleFlow()
            } label: {
                Text("애플 로그인")
            }
            
            Button {
                
            } label: {
                Text("get Current User")
                    .padding()
            }
            Button {
                FirebaseManager.instance.logOut()
            } label: {
                Text("logout").padding()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
