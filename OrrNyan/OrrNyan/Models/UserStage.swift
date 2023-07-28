//
//  UserStage.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/18.
//

import Foundation

struct UserStage {
    let id: UUID
    var currentStage: Int
    var currentStageFloors: Int
}

let userStageTestInstance: UserStage = UserStage(id: UUID(), currentStage: 3, currentStageFloors: 4)
