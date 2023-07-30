//
//  StageView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/14.
//

import SwiftUI

struct StageView: View {
    @State var showAlert: Bool = false
    @EnvironmentObject var viewModel: StageViewModel
	var nameSpace: Namespace.ID

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
//                                StageBottomView()
								
								NavigationLink(destination: MyPageView()){
									StageBottomView()
								}
                            }

                            ACarousel(viewModel.stageCarouselInfo, headspace: 80, nameSpace: nameSpace) { _ in
                            }
                            .frame(height: UIScreen.height * 0.75)
                            .offset(y: UIScreen.height * 0.01)
                        }
                    }
                    else {
                        MainView(nameSpace: nameSpace)
                        // 다음 스테이지 넘어가기 테스트용 버튼
                        Button("Show Alert") {
                            // (현재 스테이지에서 오른 층수) >= (전체 층수 - 클리어한 스테이지들의 층수) && (현재 진행하고 있는 스테이지 == 보여지고있는 스테이지) 일 때 팝업 띄움 
                            if userStageTestInstance.currentStageFloors >= userFloorTestInstance.totalFloors - sumOfClearedStages(array: viewModel.stageCarouselInfo.map { $0.floors }, n: userStageTestInstance.currentStage - 1) && userStageTestInstance.currentStage - 1 == viewModel.selectedIndex {
                                showAlert = true
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("축하한다냥!"), message: Text("스테이지 클리어!"), dismissButton: .default(Text("클리어!")) {
                                viewModel.isMainDisplayed = false
                                if viewModel.stageCarouselInfo.count > userStageTestInstance.currentStage {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                                        userStageTestInstance.currentStage += 1
                                        UserDefaults.standard.set(userStageTestInstance.currentStage - 1, forKey: "focusedStageIndex")
                                    }
                                }
                            })
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    /// 지금껏 클리어한 스테이지들의 계단 수 합
    ///
    /// - Parameters:
    ///     - array: 전체 스테이지의 계단 수 합
    ///     - n: 현재 스테이지
    func sumOfClearedStages(array: [Int], n: Int) -> Int {
        let endIndex = min(n, array.count) // n이 배열의 크기를 초과하지 않도록 보장
        return array.prefix(endIndex).reduce(0, +)
    }
}

//struct StageView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        StageView()
//            .environmentObject(StageViewModel())
//    }
//}
