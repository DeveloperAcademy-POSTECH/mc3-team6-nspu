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
<<<<<<< HEAD
//            SettingPopupView()
            //			StageView()
//                                    ContentView()
//                                        .environmentObject(firebaseManager)
//                                        .environmentObject(stageViewModel)
//                        StageView()
//                            .environmentObject(StageViewModel())
			MyPageView()
//			ContentView()
=======

                        SantaTestView()
            //
            //            			StageView()
            //                        ContentView()
            //                            .environmentObject(firebaseManager)
            //                            .environmentObject(stageViewModel)
            //                        StageView()
            //                            .environmentObject(StageViewModel())
>>>>>>> 5f3e7cc1d16387720ba50e2801e0588e14c11e99
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
