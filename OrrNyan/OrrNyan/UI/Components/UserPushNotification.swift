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
    
    var isAlertEnabled: Bool = false
    var setTime: Date? = nil
    
    // user sets notification authorization
    @Published var isToggleOn: Bool = UserDefaults.standard.bool(forKey: "agreedNoti"){
        didSet{
            if isToggleOn {
                UserDefaults.standard.set(true, forKey: "agreedNoti")
                isAlertEnabled = true
                
                requestNotificationAuthorization()
            }
            else {
                UserDefaults.standard.set(false, forKey: "agreedNoti")
                isAlertEnabled = false
                UserDefaults.standard.set(nil, forKey: "AlertTime")
                cancelNotification()
            }
        }
    }
    
    // notification time
    @Published var notiTime: Date = UserDefaults.standard.object(forKey: "AlertTime") as? Date ?? Date() {
        didSet{
            // remove old noti time
            cancelNotification()
            
            guard isAlertEnabled else { return }
            
            UserDefaults.standard.set(notiTime, forKey: "AlertTime")
            
            // set to new noti time
            addNotification(with: notiTime)
        }
    }
    
    // notification non authorized
    @Published var isShowAuthAlert: Bool = false
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    let notificationAuthOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
    
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
                    if granted { }
                    // first denied
                    else { }
                    }
                }
            
            // if auth set to deny
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self.isShowAuthAlert = true
                }
            }
        }
    }
    
    // add notification
    func addNotification(with time: Date) {
        let notificationContent = UNMutableNotificationContent()
        
        // set title and content of nofitication
        notificationContent.title = "테스트다냥!"
        notificationContent.body = "알림 테스트다냥!"
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
