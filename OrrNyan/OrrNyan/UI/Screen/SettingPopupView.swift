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
    
    // Audio manage
    @StateObject var myAudio = AudioManager.instance
    
    // Notification manage
    @StateObject private var notiManager = UserPushNotification.instance
    
    @State var test = false
    
    @State var isConfirmationRequired = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    @State var isToggleOn: Bool = false
    
    var body: some View {
        NavigationStack{
            Form {
                // Test Code =================================
                Toggle("Test", isOn: $test)
                    .confirmationDialog("이것보라냥",isPresented: $test, titleVisibility: .visible,
                                        actions: {
                        Button("알림 설정냥") {notiManager.openDeviceSetting()}
                        Button("취소냥", role:.cancel) {}
                    }, message: {
                        Text("알림 권한이 필요하다냥!")
                    })
                // Test Code =================================
                
                Toggle("PUSH 알림", isOn: $isToggleOn)
                    .onAppear{
                        notiManager.checkAuthorization()
                        self.isToggleOn = UserDefaults.standard.bool(forKey: "isToggleOn")
                    }
                    .onChange(of: isToggleOn) { isOn in
                        if isOn {
                            UserDefaults.standard.set(true, forKey: "isToggleOn")
                            notiManager.isToggleOn = true
                            isConfirmationRequired = UserDefaults.standard.bool(forKey: "askAuth")
                        } else {
                            notiManager.isToggleOn = false
                            UserDefaults.standard.set(false, forKey: "isToggleOn")
                        }
                    }
                    .onChange(of: scenePhase) { phase in
                        notiManager.checkAuthorization()
                        switch phase {
                        case .active:
                            if isToggleOn {
                                UserDefaults.standard.set(true, forKey: "isToggleOn")
                                self.isToggleOn = UserDefaults.standard.bool(forKey: "isNotiAuthorized")
                            } else {
                                self.isToggleOn = UserDefaults.standard.bool(forKey: "isToggleOn")
                            }
                        default : break
                        }
                    }
                    .confirmationDialog("이거보라냥!",isPresented: $isConfirmationRequired, titleVisibility: .visible,
                                        actions: {
                        Button("알림 설정냥") {notiManager.openDeviceSetting()}
                        Button("취소냥", role:.cancel) {
                            self.isToggleOn = false
                            UserDefaults.standard.set(false, forKey: "isToggleOn")
                            UserDefaults.standard.set(true, forKey: "askAuth")
                        }}, message: {
                            Text("알림 권한이 필요하다냥!")
                        })
                HStack{
                    Text("알림시간")
                    Spacer()
                    Button(action: {
                        withAnimation(.easeIn){
                            self.isWheelShow.toggle()
                        }
                    },label: {
                        Text(notiManager.notiTime, style: .time)
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
                    DatePicker(selection: $notiManager.notiTime, displayedComponents: .hourAndMinute, label: {})
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                
                // turn on and off BGM
                Toggle("배경음", isOn: $myAudio.isBGMEnabled)
                
                // turn on and off sound effects
                Toggle("효과음", isOn: $myAudio.isSFXEnabled)
                
                // test code =========================================
                
                Button("Test Button"){
                    AudioManager.instance.playSFX(fileName: "TestMeow", fileType: "wav")
                }
                // test code =========================================
            }
            .toggleStyle(SwitchToggleStyle(tint: Color.Purple200))
            .bold()
        }
    }
}



struct SettingPopupView_Previews: PreviewProvider {
    static var previews: some View {
        SettingPopupView()
    }
}
