//
//  SettingPopupView.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/20.
//
import SwiftUI

struct SettingPopupView: View {
    @State var isWheelShow = false
    
    // Audio manage
    @StateObject var myAudio = AudioManager.instance
    
    // Notification manage
    @StateObject private var notiManager = UserPushNotification.instance
    
	@Binding var isSettingPopupViewShow : Bool
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dismiss) var dismiss
    
    // is confirmation dialog required == not authorized notification
    @State var isConfirmationRequired = false
    
    var body: some View {
        ZStack{
            VStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 36, height: 5)
                    .background(Color.White100)
                    .cornerRadius(2.5)
                
                Form {
                    Section{
                        Toggle("PUSH 알림", isOn: $notiManager.isToggleOn)
                            .onAppear{
                                checkAuth()
                            }
                            .onChange(of: notiManager.isToggleOn) { isOn in
                                if isOn {
                                    notiManager.isToggleOn = true
                                    
                                    if UserDefaults.standard.bool(forKey: "launchedBefore") {
                                        isConfirmationRequired = !UserDefaults.standard.bool(forKey: "isNotificationAuthorized")}
                                } else {
                                    notiManager.isToggleOn = false
                                }
                            }
                            .onChange(of: scenePhase) { phase in
                                switch phase {
                                case .active:
                                    print("화면 전환 \(phase)")
                                    checkAuth()
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
                    } header: {
                        Text("")
                            .padding(.top, 10)
                    }
                }
                .toggleStyle(SwitchToggleStyle(tint: Color.Purple200))
                .bold()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
				.overlay(alignment: .topTrailing){close.onTapGesture {
					isSettingPopupViewShow = false
				}}
            }
        }
        .padding(.top, 24)
        .background(Color.White200)
    }
}

func checkAuth() {
    UNUserNotificationCenter.current().getNotificationSettings { settings in
        if settings.authorizationStatus == .authorized {
            // set values
            DispatchQueue.main.async {
                UserPushNotification.instance.isNotiAuthorized = true
                UserPushNotification.instance.isToggleOn = UserDefaults.standard.bool(forKey: "isToggleOn")}
        }
        else {
            // set values
            DispatchQueue.main.async {
                UserPushNotification.instance.isNotiAuthorized = false
                UserPushNotification.instance.isToggleOn = false
            }
        }
    }
}

private extension SettingPopupView {
    var close: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .bold()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.Black200.opacity(0.5))
                .background(Color.Gray200.opacity(0.2))
                .clipShape(Circle())
                .padding(.horizontal, 16)
                .padding(.bottom, 0.0)
                .padding(.top, 0)
        }
    }
}

struct SettingPopupView_Previews: PreviewProvider {
    static var previews: some View {
		SettingPopupView(isSettingPopupViewShow : .constant(false))
    }
}
