//
//  OrrNyanApp.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/12.
//

import FirebaseCore
import GoogleSignIn
import SwiftUI

@main
struct OrrNyanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var firebaseManager = FirebaseManager()
    @StateObject var stageViewModel = StageViewModel()
	@StateObject var isFirstLaunch = AppFirstLaunch()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firebaseManager)
                .environmentObject(stageViewModel)
				.environmentObject(isFirstLaunch)
                .onAppear(){
                    Task {
                        // userInfo
                        try await firebaseManager.fetchUserInfo()
                        // userFloor
                        User.instance.userFloor = User.instance.fetchFloorsFromUserDefaults()
                        User.instance.updateFloorsData()
                        User.instance.userStage = try await firebaseManager.readUserStage()
                    }
                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    // Firebase 설정
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        FirebaseApp.configure()
        
        return true
    }
    
    // Google Login 설정
    func application(_: UIApplication, open url: URL, options _:
                     [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool
    {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
