//
//  LoginView_malty.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/19.
//

import SwiftUI

struct LoginView_malty: View {
    @State private var showCreateNameView = false
    var body: some View {
        NavigationStack {
            // MARK: - LoginView

            VStack(spacing: 10) {
                LottieView(filename: "firstCat")
                    .frame(maxWidth: .infinity)
                    .frame(height: 330)
                    .padding(.top, 130)

                Text("귀여운 고양이와 함께\n계단을 올라보자냥!")
                    .font(.pretendard(size: 18, .bold))
                    .multilineTextAlignment(.center)

                Spacer()

                loginButton(logoTitle: "ImgLogoApple", text: "Apple로 로그인", buttonColor: Color.black, fontColor: Color.white)

                loginButton(logoTitle: "ImgLogoGoogle", text: "Google로 로그인", buttonColor: Color.white, fontColor: Color.black)

                    .padding(.bottom, 35)
            }
            .padding(.horizontal, 30)
            .ignoresSafeArea()
        }
    }

    // MARK: - 로그인 버튼

    /// 로그인 버튼
    private func loginButton(logoTitle: String, text: String, buttonColor: Color, fontColor: Color) -> some View {
        NavigationLink {
            // 제이 여기다가 로그인 함수 넣어주면 돼요
            CreateNameView()
        } label: {
            HStack {
                // Logo Image
                Image(logoTitle)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)

                Spacer()

                // Text Area
                Text(text)
                    .font(.pretendard(size: 17, .bold))
                    .foregroundColor(fontColor)
                    .padding(.vertical, 17.5)

                Spacer()
//
            }
            .padding(.leading, 16)
            .padding(.trailing, 40)
        }
        .frame(maxWidth: .infinity)
        .background(buttonColor)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.15), radius: 3.5, x: 0, y: 0)
    }
}

struct LoginView_malty_Previews: PreviewProvider {
    static var previews: some View {
        LoginView_malty()
    }
}
