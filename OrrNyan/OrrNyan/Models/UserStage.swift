//
//  UserStage.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/18.
//

import Combine
import Foundation

class UserStage: Codable{
    var id: String?
    var currentStage: Int {
        didSet {
            NotificationCenter.default.post(name: .userStageCurrentStageChanged, object: self, userInfo: ["currentStage": currentStage])
        }
    }
    var currentStageFloors: Int
    
    init(currentStage: Int, currentStageFloors: Int) {
        self.currentStage = currentStage
        self.currentStageFloors = currentStageFloors
    }
}

extension Notification.Name {
    static let userStageCurrentStageChanged = Notification.Name("UserStageCurrentStageChanged")
}
