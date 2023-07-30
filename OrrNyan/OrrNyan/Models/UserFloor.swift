//
//  UserFloor.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/18.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserFloor: Codable {
    var id: String?
    var dailyFloors: Int
    var totalFloors: Int
    var date: Date
    
    /// A function that updates totalFloors.
    mutating func updateTotalFloors(_ floor: Int) {
        self.totalFloors = totalFloors + floor
    }
}

let userFloorTestInstance: UserFloor = UserFloor(dailyFloors: 5, totalFloors: 43, date: Date())
