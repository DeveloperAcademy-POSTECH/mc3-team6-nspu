//
//  UserBadge.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/18.
//

import Foundation

struct UserBadge: Identifiable {
    let id: UUID = UUID()
    var stageCompleteArray: [Bool]
}
