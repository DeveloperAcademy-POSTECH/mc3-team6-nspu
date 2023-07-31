//
//  AppFirstLaunch.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/31.
//

import SwiftUI

class AppFirstLaunch: ObservableObject {
    @Published var isFirstlaunch : Bool = UserDefaults.standard.object(forKey: "IsFirstLaunch") == nil ? true : UserDefaults.standard.object(forKey: "IsFirstLaunch") as! Bool
}
