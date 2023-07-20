//
//  StageItem.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/19.
//

import Foundation
import SwiftUI

struct StageItem: Identifiable {
    static var indexCounter = 0
    let id = UUID()
    let index: Int
    let image: Image
    init(image: Image) {
        self.index = Self.indexCounter
        Self.indexCounter += 1
        self.image = image
    }
}
