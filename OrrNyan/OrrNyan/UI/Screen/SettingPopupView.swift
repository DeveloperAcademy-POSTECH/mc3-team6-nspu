//
//  SettingPopupView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/19.
//
import SwiftUI

struct SettingPopupView: View {
    @State var advertisement = false
    @State var alarmTime = Date()
    @State var isWheelShow = false
    @State var bGM = false
    @State var sFX = false
    
    
    var body: some View {
        
        Form {
            Toggle("PUSH알림", isOn: $advertisement)
            
            
//            HStack{
//                Text("알람시간")
//                Spacer()
//                
//                
//                Button(action: {
//
//                    if isWheelShow {
//                        isWheelShow = false
//                    }
//                    else {
//                        isWheelShow = true
//                    }
//
//                },label: {
//                    Text("알람")
//                        .bold()
//                })
//            }
//
            DatePicker(selection: $alarmTime, displayedComponents: .hourAndMinute, label: {Text("알람시간")})
                .datePickerStyle(.compact)
            
            Toggle(isOn: $bGM) {
                Text("배경음악")}
            Toggle(isOn: $sFX) {
                Text("효과음")}
        }
        .toggleStyle(SwitchToggleStyle(tint: Color("Purple200")))
    }
}


struct AlarmButton: View{
    @Binding var isWheelShow: Bool
    
    var body: some View {
        
        Button(action: {
            if isWheelShow {
                isWheelShow = false
            }
            else {
                isWheelShow = true
            }
            
        },label: {
            Text("알람")
                .bold()
                .foregroundColor(.gray)
        })
        
        
        
        
    }
}



struct SettingPopupView_Previews: PreviewProvider {
    static var previews: some View {
        SettingPopupView()
    }
}
