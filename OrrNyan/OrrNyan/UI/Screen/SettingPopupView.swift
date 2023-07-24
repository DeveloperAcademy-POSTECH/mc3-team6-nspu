//
//  SettingPopupView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/20.
//


import SwiftUI



struct SettingPopupView: View {
    @State var advertisement = false
    @State var alarmTime = Date()
    @State var isWheelShow = false
    @State var isAnimating = false
    
    // audio manage
    @StateObject var audioManager = AudioManager()
    
    var body: some View {
        
        Form {
            Toggle(isOn: $advertisement) {
                Text("PUSH 알림")}
            
            HStack{
                Text("알림시간")
                Spacer()
                Button(action: {
                    withAnimation(.easeIn){
                        
                        self.isWheelShow.toggle()
                    }
                },label: {
                    Text(alarmTime, style: .time)
                        .bold()
                        .foregroundColor(Color.Purple200)
                        .padding(.horizontal, 11)
                        .padding(.vertical, 6)
                        .background(Color.White200)
                        .cornerRadius(10)
                })
                .buttonStyle(BorderlessButtonStyle())
            }
            
            if isWheelShow{
                DatePicker(selection: $alarmTime, displayedComponents: .hourAndMinute, label: {})
                    .labelsHidden()
                    .datePickerStyle(.wheel)
            }
            
            // turn on and off BGM
            Toggle("배경음", isOn: $audioManager.isBGMEnabled)
            
            // turn on and off sound effects
            Toggle("효과음", isOn: $audioManager.isSFXEnabled)
            
        }
        .toggleStyle(SwitchToggleStyle(tint: Color.Purple200))
        .bold()
    }
}


struct SettingPopupView_Previews: PreviewProvider {
    static var previews: some View {
        SettingPopupView()
    }
}
