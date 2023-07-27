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
    let stageStImageTitle = Stages().StageInfos.map { ($0.stageStructureImageTitle, $0.stageName, $0.stageFloors) }.map { StageItem(image: Image($0), name: String($1), floors: Int($2)) }
    let stageFloors = Stages().StageInfos.map { $0.stageFloors }
    let stageNames = Stages().StageInfos.map { $0.stageName }

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
                                    .overlay(Rectangle())
                                ACarousel(stageStImageTitle, headspace: 80, nameSpace: nameSpace){ item in
                                    
                                }
                         StageBottomView()
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
