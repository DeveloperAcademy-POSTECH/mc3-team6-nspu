//
//  StageView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/14.
//

import SwiftUI

struct Item: Identifiable {
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

struct StageView: View {
    // stageStructureImageTitle을 String 배열로 만들고,
    // UUID를 포함한 Items배열로 변환해 items 변수에 저장합니다.
    let stageStImageTitle = Stages().StageInfos.map { $0.stageStructureImageTitle }.map { Item(image: Image($0)) }
    let stageFloors = Stages().StageInfos.map { $0.stageFloors }
    
    var body: some View {
        VStack {
            HeaderView()
                .padding(.top, 54)
            ACarousel(stageStImageTitle, headspace: 70, sidesScaling: 1.2) { item in
                item.image
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
