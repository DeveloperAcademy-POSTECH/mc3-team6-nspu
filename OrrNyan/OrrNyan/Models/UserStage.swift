//
//  UserStage.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/18.
//

import Combine
import Foundation

class UserStage: ObservableObject {
    let id: UUID
    @Published var currentStage: Int {
        didSet {
            NotificationCenter.default.post(name: .userStageCurrentStageChanged, object: self, userInfo: ["currentStage": currentStage])
        }
    }

    private var cancellables = Set<AnyCancellable>()
    var currentStageFloors: Int
    init(id: UUID, currentStage: Int, currentStageFloors: Int) {
        self.id = id
        self.currentStage = currentStage
        self.currentStageFloors = currentStageFloors
    }
}

var userStageTestInstance: UserStage = .init(id: UUID(), currentStage: 1, currentStageFloors: 4)

extension Notification.Name {
    static let userStageCurrentStageChanged = Notification.Name("UserStageCurrentStageChanged")
}
