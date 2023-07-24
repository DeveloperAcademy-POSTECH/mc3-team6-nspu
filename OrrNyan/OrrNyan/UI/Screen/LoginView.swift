//
//  LoginView.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/16.
//

import SwiftUI

struct LoginView: View {
    @StateObject var signInWithApple = SignInWithApple()
    @StateObject var signInWithGoogle = SignInWithGoogle()
    @State var isLoginSuccessed = false

    var body: some View {
        VStack {
            Button {
                Task {
                    try await signInWithGoogle.signInWithGoogle()
                    isLoginSuccessed = signInWithGoogle.isLoginSuccessed
                }
            } label: {
                Text("구글 로그인")
            }

            Button {
                DispatchQueue.main.async {
                    signInWithApple.startSignInWithAppleFlow()
                }
                isLoginSuccessed = signInWithApple.isLoginSuccessed
            } label: {
                Text("애플 로그인")
                    .onChange(of: signInWithApple.isLoginSuccessed) { newValue in
                        isLoginSuccessed = newValue
                    }
            }

            Button {
                Task {
                    try await FirebaseManager.instance.createUser("말티")
                }
            } label: {
                Text("유저 저장")
                    .padding()
            }

            Button {
                Task {
                    try await FirebaseManager.instance.readUserData()
                }
            } label: {
                Text("유저 데이터 가져오기")
            }

            Button {
                FirebaseManager.instance.createUserFloor(userFloor: UserFloor(dailyFloors: 0, totalFloors: 0, date: Date()))
            } label: {
                Text("UserFloor 추가")
            }

            Button {
                Task {
                    try await FirebaseManager.instance.readUserFloor()
                }
            } label: {
                Text("UserFloor 읽기")
            }

            Button {
                Task {
                    try await FirebaseManager.instance.updateUserFloor()
                }
            } label: {
                Text("UserFloor 업데이트")
            }

            Button {
                FirebaseManager.instance.logOut()
            } label: {
                Text("logout").padding()
            }

            if isLoginSuccessed {
                Text("로그인 버튼눌리고, 성공했다")
            } else {
                Text("실패했다. 안눌리거나")
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
