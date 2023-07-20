//
//  StageView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/14.
//

import SwiftUI

class StageViewModel: ObservableObject {
    @Published var selectedIndex: Int = 0
    @Published var isMainDisplayed: Bool = false
}

struct StageView: View {
    // stageStructureImageTitle을 String 배열로 만들고,
    // UUID를 포함한 Items배열로 변환해 items 변수에 저장합니다.
    let stageStImageTitle = Stages().StageInfos.map { $0.stageStructureImageTitle }.map { StageItem(image: Image($0)) }
    let stageFloors = Stages().StageInfos.map { $0.stageFloors }
    @State var selectedIndex: Int = 0
    @EnvironmentObject var viewModel: StageViewModel
    @Namespace var nameSpace
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.isMainDisplayed {
                    MainTopView()
                        .zIndex(.infinity)
                    ACarousel(stageStImageTitle, headspace: 10) { item in
                        ZStack {
                            item.image
                                .resizable()
                                .scaledToFill()
                                .matchedGeometryEffect(id: "StageStImage0\(item.index + 1)", in: nameSpace)
                                .onTapGesture {
                                    viewModel.selectedIndex = item.index
                                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6)) {
                                        viewModel.isMainDisplayed = true
                                    }
                                }
                        }
                    }
                }
                else {
                    MainView(nameSpace: nameSpace)
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
