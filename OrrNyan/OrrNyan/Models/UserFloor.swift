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
    @DocumentID var id: String?
    var dailyFloors: Int
    var totalFloors: Int
    var date: Date
}
