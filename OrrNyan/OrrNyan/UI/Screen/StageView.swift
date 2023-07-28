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

    @EnvironmentObject var viewModel: StageViewModel
    @Namespace var nameSpace

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Color.White200
                    if !viewModel.isMainDisplayed {
                        ZStack {
                            VStack {
                                MainTopView()
                                    .zIndex(.infinity)
                                Spacer()
                                StageBottomView()
                            }

                            ACarousel(viewModel.stageCarouselInfo, headspace: 80, nameSpace: nameSpace) { _ in
                            }
                            .frame(height: UIScreen.height * 0.75)
                            .offset(y: UIScreen.height * 0.01)
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
