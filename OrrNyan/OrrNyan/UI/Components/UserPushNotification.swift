//
//  UserPushNotification.swift
//  OrrNyan
//
//  Created by Park Jisoo on 2023/07/25.
//

import SwiftUI
import UserNotifications

class UserPushNotification: ObservableObject {
    
    // singleton
    static let instance = UserPushNotification()
    private init() {}
    
    @State var user : UserInfo? = User.instance.userInfo
    
    //save last alert time
    var lastSetTime: Date? = nil
  
    // user notification center
    let userNotificationCenter = UNUserNotificationCenter.current()
    let notificationAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
    
    // current setting value
    @Published var isNotiAuthorized: Bool = UserDefaults.standard.bool(forKey: "isNotificationAuthorized"){
        didSet{
            if isNotiAuthorized {
                UserDefaults.standard.set(true, forKey: "isNotificationAuthorized")
            } else {
                UserDefaults.standard.set(false, forKey: "isNotificationAuthorized")
            }
        }
    }
    
    
    
    // user sets notification authorization
    @Published var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "isToggleOn"){
        didSet{
            if isToggleOn {
                UserDefaults.standard.set(true, forKey: "isToggleOn")
                // execute only once
                if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
                    requestNotificationAuthorization()
                }
                addNotification(with: notiTime)
            } else {
                UserDefaults.standard.set(false, forKey: "isToggleOn")
                cancelNotification()
            }
        }
    }
    
    // notification time
    @Published var notiTime: Date = UserDefaults.standard.object(forKey: "AlertTime") as? Date ?? Date(){
        didSet{
            // remove old noti time
            cancelNotification()
            guard isToggleOn else { return }
            
            UserDefaults.standard.set(notiTime, forKey: "AlertTime")
            // set to new noti time
            addNotification(with: notiTime)
        }
    }
    
    // request notification authorization
    func requestNotificationAuthorization() {
        userNotificationCenter.getNotificationSettings { settings in
            // if not authorized
            if settings.authorizationStatus != .authorized {
                self.userNotificationCenter.requestAuthorization(options: self.notificationAuthOptions) { (granted, error) in
                    if let error = error {
                        print("권한 오류다냥! \(error.localizedDescription)")
                    }
                    // first auth granted
                    if granted {
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        UserDefaults.standard.set(true, forKey: "isNotificationAuthorized")
                        UserDefaults.standard.set(true, forKey: "isToggleOn")
                        DispatchQueue.main.async {
                            self.isNotiAuthorized = true
                            self.isToggleOn = true
                        }
                    }
                    // first denied
                    else{
                        UserDefaults.standard.set(true, forKey: "launchedBefore")
                        UserDefaults.standard.set(false, forKey: "isNotificationAuthorized")
                        UserDefaults.standard.set(false, forKey: "isToggleOn")
                        DispatchQueue.main.async {
                            self.isNotiAuthorized = false
                            self.isToggleOn = false
                        }
                    }
                }
            }
        }
    }
    
    // add notification
    func addNotification(with time: Date) {
        let notificationContent = UNMutableNotificationContent()
        
        // set title and content of nofitication
        notificationContent.title = "\(user?.nickName ?? "길냥이") : 설마.. 엘레베이터 탈꺼냥?"
        notificationContent.body = "계단 오르자냥!"
        notificationContent.sound = UNNotificationSound.default
        
        // set time
        let timeComponent = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        // trigger setting
        let trigger = UNCalendarNotificationTrigger(dateMatching: timeComponent, repeats: true)
        
        // create notification
        let request = UNNotificationRequest(identifier: "TestNotification", content: notificationContent, trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print ("알림 오류다냥! \(error)")
            }
        }
    }
    
    // cancel all notifications
    func cancelNotification() {
        userNotificationCenter.removeAllPendingNotificationRequests()
        userNotificationCenter.removeAllDeliveredNotifications()
    }
    
    // move to device setting
    func openDeviceSetting() {
        if let bundle = Bundle.main.bundleIdentifier,
           let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
            if UIApplication.shared.canOpenURL(settings){
                UIApplication.shared.open(settings)
            }
        }
    }
}
