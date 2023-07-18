//
//  StageInfo.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/18.
//

import Foundation

struct StageInfo: Codable, Hashable, Identifiable {
    let id = UUID()
    let stageName: String
    let stageStructureImageTitle: String
    let stageBgImageTitle: String
    let stageBgElementArray: [String]
    let stageLocation: String
    let stageFloors: Int
    let stageHeight: Int
}

final class Stages {
    var StageInfos: [StageInfo] = load("StageInfo.json")
}
