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

    var body: some Scene {
        WindowGroup {
//            SettingPopupView()
            //			StageView()
            ContentView()
                .environmentObject(firebaseManager)
                .environmentObject(stageViewModel)
//                        StageView()
//                            .environmentObject(StageViewModel())
//            MainParallaxView()
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
