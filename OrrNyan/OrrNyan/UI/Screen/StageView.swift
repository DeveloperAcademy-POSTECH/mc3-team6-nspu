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
    let stageStImageTitle = Stages().StageInfos.map { $0.stageStructureImageTitle }.map { StageItem(image: Image($0)) }
    let stageFloors = Stages().StageInfos.map { $0.stageFloors }

    @EnvironmentObject var viewModel: StageViewModel
    @Namespace var nameSpace

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if !viewModel.isMainDisplayed {
                        ZStack {
                            VStack {
                                MainTopView()
                                    .zIndex(.infinity)
                                Spacer()
                                ACarousel(stageStImageTitle, headspace: 80) { item in
                                    ZStack {
                                        item.image
                                            .resizable()
                                            .scaledToFill()
                                            .matchedGeometryEffect(id: "StageStImage0\(item.index + 1)", in: nameSpace)
                                            .onTapGesture {
                                                if UserDefaults.standard.object(forKey: "stageActiveIndex") as! Int == item.index && userStageTestInstance.currentStage > item.index {
                                                    UserDefaults.standard.set(item.index, forKey: "selectedStageIndex")
                                                    viewModel.selectedIndex = item.index
                                                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6)) {
                                                        viewModel.isMainDisplayed = true
                                                    }
                                                }
                                            }
                                    }
                                }
                                VStack {
                                    Image("TextDivider")
                                }
                                MainBottomView()
                            }
                        }
                    }
                    else {
                        MainView(nameSpace: nameSpace)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(StageViewModel())
    }
}
