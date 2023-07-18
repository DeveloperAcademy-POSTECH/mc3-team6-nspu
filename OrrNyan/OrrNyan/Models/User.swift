//
//  UserModel.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let email: String
    var nickName: String
    var lastVisitDate: Date?
    var createdAt: Date?
}
