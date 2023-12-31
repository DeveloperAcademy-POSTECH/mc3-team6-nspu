//
//  CreateNameView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/18.
//

import Foundation
import SwiftUI

enum catNameStatus: String {
    case tooLong = "8글자 이하만 가능하다냥."
    case specialCharater = "특수문자는 사용이 불가능하다냥."
    case emptySpace = "공백을 사용할 수 없다냥"
    case availableName = ""
    case idle = " "
}

struct CreateNameView: View {
    
    @EnvironmentObject var firebaseManager: FirebaseManager
    @State var catName = ""
    @State var isShowAlert = false
    @State var isInput = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0){
                LottieView(filename: "LottieCreateNameView")
                    .frame(maxWidth: .infinity)
                    .frame(height: DeviceSize.width > DeviceSize.iPhoneSE  ? 330 : 250)
                    .padding(.top,  DeviceSize.width > DeviceSize.iPhoneSE  ? 50 : 20 )
                
                Text("내 이름은 뭐냥?")
                    .font(.pretendard(size: 18, .bold))
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                
                
                nickNameInput(placeHolder: "정해달라")
                
                
                // inform whether cat name is valid or not
                Text(isValid().rawValue)
                    .foregroundColor(isValid() == catNameStatus.availableName ? Color.Black300 : Color.Pink300)
                    .font(.custom("Pretendard-Regular", size: 15))
                    .padding(.top, 5)
                    .padding(.leading, 65)
                Spacer()
                // confirm cat name and complete sign up
                Button(action: {
                    // alert pop up
                    isShowAlert = true
                }, label: {
                    Text("시작하기")
                        .bold()
                })
                .disabled(isValid() == catNameStatus.availableName ? false : true)
                .buttonStyle(CatButtonStyle())
                .padding(.bottom, DeviceSize.width > DeviceSize.iPhoneSE  ? 50 : 20)
                // alert pop up
                .alert("이름 확정인거냥?", isPresented: $isShowAlert) {
                    Button(action: {
                        Task {
                            try await firebaseManager.createUser(catName)
                        }})
                    {
                        Text("확인")
                    }
                    Button("취소") {
                        isShowAlert = false
                    }
                } message: { Text("한 번 정하면 바꿀 수 없다냥.") }
            }
            .ignoresSafeArea()
        }
        .padding(.horizontal, 35)
    }
    
    // input field
    private func nickNameInput(placeHolder:String) -> some View {
        VStack {
            HStack {
                TextField("정해달라", text: $catName)
                    .font(.pretendard(size:22, .bold))
                    .foregroundColor(hasInput(catNameStatus: isValid()) ? Color.Black300 : Color.Pink300)
                
                Spacer()
                
                Text("냥")
                    .font(.pretendard(size:22, .bold))
            }
            .padding(.bottom, 6)
            .overlay(alignment:.bottom){
                Rectangle()
                    .frame(height: 2)
            }
            .padding(.horizontal, 65)
        }
        .foregroundColor(hasInput(catNameStatus: isValid()) ? Color.Purple300 : Color.Pink300)
        .padding(.top, 30)
    }
    
    
    // check if cat name is appropriate
    // has special character
    // has empty space
    // no input
    // 1~8 letters & no special character
    // more than 8 letters
    func isValid() -> catNameStatus {
        // only en, ko, nums
        let pattern = "[^a-z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        if let _ = regex.firstMatch(in: catName, options: [], range: NSMakeRange(0, catName.count))
        {
            return catNameStatus.specialCharater
        }
        
        // check catName length, spaces
        switch catName {
        case _ where catName.contains(" "):
            return catNameStatus.emptySpace
        case _ where catName.contains("\t"):
            return catNameStatus.emptySpace
        case _ where catName.count == 0:
            return catNameStatus.idle
        case _ where catName.count < 9:
            return catNameStatus.availableName
        default:
            return catNameStatus.tooLong
        }
    }
    
    // check name availability
    func hasInput(catNameStatus: catNameStatus) -> Bool {
        switch catNameStatus {
        case .availableName:
            return true
        case .idle:
            return true
        default:
            return (false)
        }
    }
}

struct CreateNameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNameView()
    }
}
