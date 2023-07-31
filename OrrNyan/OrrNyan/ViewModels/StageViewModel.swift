//
//  StageViewModel.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/24.
//

import Foundation
import SwiftUI

class StageViewModel: ObservableObject {
    @Published var selectedIndex: Int = UserDefaults.standard.object(forKey: "focusedStageIndex") == nil ? 0 : UserDefaults.standard.object(forKey: "focusedStageIndex") as! Int
    @Published var isMainDisplayed: Bool = false
    @Published var isLaunched: Bool = true
    
    let stageCarouselInfo = Stages().StageInfos.map { ($0.stageStructureImageTitle, $0.stageName, $0.stageFloors) }.map { StageItem(image: Image($0), name: String($1), floors: Int($2)) }
}
