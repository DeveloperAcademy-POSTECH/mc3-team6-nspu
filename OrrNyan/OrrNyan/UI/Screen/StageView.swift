//
//  StageView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/14.
//

import SwiftUI

struct StageView: View {
    // stageStructureImageTitle을 String 배열로 만들고,
    // UUID를 포함한 Items배열로 변환해 items 변수에 저장합니다.
    let stageStImageTitle = Stages().StageInfos.map { $0.stageStructureImageTitle }.map { Item(image: Image($0)) }
    let stageFloors = Stages().StageInfos.map { $0.stageFloors }
    @Namespace var nameSpace
    var body: some View {
        VStack {
            MainTopView()
                .zIndex(.infinity)
            ACarousel(stageStImageTitle, headspace: 60) { item in
                item.image
                    .resizable()
                    .scaledToFill()
                    .matchedGeometryEffect(id: "StageStImage\(item.index)", in: nameSpace)
                    .onTapGesture {
                        print(item.index)
//                        TestTransitionView()
                    }
            }
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
    }
}
