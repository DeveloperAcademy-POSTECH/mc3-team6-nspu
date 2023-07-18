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
                FirebaseManager.instance.createUser("말티")
            } label: {
                Text("유저 저장")
                    .padding()
            }
            
            Button {
                FirebaseManager.instance.readUserData()
            } label: {
                Text("유저 데이터 가져오기")
            }
            
            Button {
                FirebaseManager.instance.writeUserFloor(userFloor: UserFloor(dailyFloors: 0, totalFloors: 0, date: Date()))
            } label: {
                Text("UserFloor 추가")
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
