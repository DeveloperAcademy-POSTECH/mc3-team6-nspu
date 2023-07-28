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
    
    // test code
    @State var test = false
    
    @Environment(\.scenePhase) private var scenePhase
    
    // is confirmation dialog required == not authorized notification
    @State var isConfirmationRequired = false
    
    let testKey: String = "test"
    
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
                
                
                
                Toggle("PUSH 알림", isOn: $notiManager.isToggleOn)
                    .onAppear{
                        
                        print("나타났다! \(notiManager.isToggleOn)")
                        notiManager.checkAuthorization()
                        
                        if notiManager.isNotiAuthorized == false {
                            notiManager.isToggleOn = false
                            print("나타났다! if문")
                        }
                        else {
                            print("나타났다! else문")
                            notiManager.isToggleOn = UserDefaults.standard.bool(forKey: "isToggleOn")
                        }
                    }
                    .onChange(of: notiManager.isToggleOn) { isOn in
                        if isOn {
                            notiManager.isToggleOn = true
                            
                            if UserDefaults.standard.bool(forKey: "launchedBefore") {
                                isConfirmationRequired = !UserDefaults.standard.bool(forKey: "isNotificationAuthorized")}
                            else {
                                notiManager.isToggleOn = false
                            }
                        }}
                    .onChange(of: scenePhase) { phase in
                        notiManager.checkAuthorization()
                        switch phase {
                        case .active:
                            print("활성!")
                            if notiManager.isNotiAuthorized {
                                print("활성! 토글 온!")
                                notiManager.isToggleOn = true
                            } else {
                                print("활성! 토글 오프!")
                                notiManager.isToggleOn = false
                            }
                            print("신 변화! \(phase)")
                        case .background :
                            print("백그라운드! ")
                        case .inactive :
                            print("비활성!")
                        default: break
                        }}
                    .confirmationDialog("이거보라냥!",isPresented: $isConfirmationRequired, titleVisibility: .visible,
                                        actions: {
                        Button("알림 설정냥") {notiManager.openDeviceSetting()}
                        Button("취소냥", role:.cancel) {
                            notiManager.isToggleOn = false
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
