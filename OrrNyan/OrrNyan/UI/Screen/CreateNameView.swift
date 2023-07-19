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
    @State var catName = ""
    @State var isShowAlert = false
    @State var isInput = false
    
    // change color of cancel button in Alert
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .gray
    }
    
    var body: some View {
        VStack{
            LottieView(filename: "firstCat")
                .frame(width: 330, height: 380)
                .padding(.top, 50)
            Text("내 이름은 뭐냥?")
                .padding(.top, 20)
            VStack{
                VStack(alignment: .center){
                    HStack{
                        // input field
                        TextField("정해달라", text: $catName)
                            .frame(width: 180, height: 0)
                            .foregroundColor(hasInput(curNameStatue: isValid()) ? Color("Black300") : Color("Pink300"))
                        Text("냥")
                            .bold()
                    }
                    .offset(y: 10)
                    // underline
                    Rectangle()
                        .frame(width: 200, height: 2)
                }
                .foregroundColor(hasInput(curNameStatue: isValid()) ? Color("Purple300") : Color("Pink300"))
                
                // inform whether cat name is valid or not
                Text(isValid().rawValue)
                    .foregroundColor(isValid() == catNameStatus.availableName ? Color.black : Color("Pink300"))
            }
            .frame(width: 330, alignment: .center)
            
            Spacer()
            
            // confirm cat name and complete sign up
            Button(action: {
                // alert pop up
                isShowAlert = true
            },label: {
                Text("시작하기")
                    .bold()
            })
            .disabled(isValid() == catNameStatus.availableName ? false : true)
            .buttonStyle(CatButtonStyle())
            .padding(.bottom, 50)
            // alert pop up
            .alert("이름 확정인거냥?", isPresented: $isShowAlert) {
                Button("확인", role: .destructive){
                    // save data
                    // do something
                    
                }
                Button("취소", role: .cancel){
                }
            } message: {
                Text("한 번 정하면 바꿀 수 없다냥.")
            }
        }
        .padding(.horizontal, 35)
    }


// check if cat name is appropriate
// has special character
// has empty space
// no input
// 1~8 letters & no special character
// more than 8 letters
    func isValid() -> catNameStatus{
        var curCatName: catNameStatus = catNameStatus.idle
        
        // only en, ko, nums
        let pattern = "[^a-z0-9가-힣ㄱ-ㅎㅏ-ㅣ\\s]"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        
        if let _ = regex.firstMatch(in: catName, options: [], range: NSMakeRange(0, catName.count))
        {
            curCatName = catNameStatus.specialCharater
            return (curCatName)
        }
        
        // check catName length, spaces
        switch catName {
        case _ where catName.contains(" ") :
            curCatName = catNameStatus.emptySpace
            return (curCatName)
        case _ where catName.contains("\t") :
            curCatName = catNameStatus.emptySpace
            return (curCatName)
        case _ where catName.count  == 0 :
            curCatName = catNameStatus.idle
            return (curCatName)
        case _ where catName.count < 9 :
            curCatName = catNameStatus.availableName
            return (curCatName)
        default:
            curCatName = catNameStatus.tooLong
            return (curCatName)
        }
    }
    
    
    // check name availability
    func hasInput (curNameStatue: catNameStatus) -> Bool {
        switch curNameStatue {
        case catNameStatus.availableName :
            return true
        case catNameStatus.idle :
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
