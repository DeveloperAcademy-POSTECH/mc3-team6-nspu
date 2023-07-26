//
//  StageViewModel.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/24.
//

import Foundation
import SwiftUI

class StageViewModel: ObservableObject {
    @Published var selectedIndex: Int = UserDefaults.standard.object(forKey: "selectedStageIndex") == nil ? 0 : UserDefaults.standard.object(forKey: "selectedStageIndex") as! Int
    @Published var isMainDisplayed: Bool = false
}
