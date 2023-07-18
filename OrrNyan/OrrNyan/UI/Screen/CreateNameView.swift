//
//  CreateNameView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/18.
//

import Foundation
import SwiftUI

enum catNameStatus: String {
    case idle = "내 이름을 입력해냥!"
    case tooLong = "8글자 이내만 가능하다냥"
    case specialCharater = "특수문자는 안된다냥"
    case emptySpace = "공백은 안된다냥"
    case availableName = "좋다냥!"
}


struct CreateNameView: View {
    @State var catName = ""
    @State var isValidName = catNameStatus.idle
    @State var isShowAlert = false
    
    
    var body: some View {
        VStack{
            LottieView(filename: "firstCat")
                .frame(width: 250, height: 250)
            Text("고양이의 이름을 지어주세요")
            
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading){
                        // input field
                        TextField("낭의 이름은", text: $catName)
                        
                        // underline
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.black)
                    }
                    Text("냥")
                }
                
                // inform whether cat name is valid or not
                Text(isValid().rawValue)
                    .foregroundColor(isValid() == catNameStatus.availableName ? Color.blue : Color.red)
            }
            .padding(.horizontal, 50)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            // confirm cat name and complete sign up
            Button(action: {
                // alert pop up
                isShowAlert = true
            },label: {
                Text("이름 저장")
            })
            .disabled(isValid() == catNameStatus.availableName ? false : true)
            .buttonStyle(CatButtonStyle())
            .padding(.bottom, 50)
            .padding(.horizontal, 20)
            // alert pop up
            .alert("내 이름이 확정인거냥?", isPresented: $isShowAlert) {
                Button("저장", role: .destructive){
                    // save data
                    // do something
                }
                Button("취소", role: .cancel){}
            } message: {
                 Text("한번 정하면 바꿀 수 없다냥")
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 100)
    }
    
    
    
    // check if cat name is appropriate
    // has special character
    // has empty space
    // no input
    // 1~8 letters & no special character
    // more than 8 letters

    func isValid() -> catNameStatus {
        var curNameStatus = catNameStatus.idle
        
        // only en, ko, nums
        let pattern = "[^a-z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)

        if let _ = regex.firstMatch(in: catName, options: [], range: NSMakeRange(0, catName.count))
        {
            curNameStatus = catNameStatus.specialCharater
            return curNameStatus
        }
        
        // check catName length, spaces
        switch catName {
        case _ where catName.contains(" ") :
            curNameStatus = catNameStatus.emptySpace
            return curNameStatus
            
        case _ where catName.contains("\t") :
            curNameStatus = catNameStatus.emptySpace
            return curNameStatus
            
        case _ where catName.count  == 0 :
            curNameStatus = catNameStatus.idle
            return curNameStatus
            
        case _ where catName.count < 9 :
            curNameStatus = catNameStatus.availableName
            return curNameStatus
        
        default:
            curNameStatus = catNameStatus.tooLong
            return curNameStatus
        }
    }
}
        
        
        
    

struct CreateNameView_Previews: PreviewProvider {
    static var previews: some View {
        CreateNameView()
    }
}
