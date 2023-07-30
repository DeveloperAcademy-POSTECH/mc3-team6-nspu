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
                        Button("Show Alert") {
                            showAlert = true
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

    func sumOfClearedStages(array: [Int], n: Int) -> Int {
        let endIndex = min(n, array.count) // n이 배열의 크기를 초과하지 않도록 보장
        return array.prefix(endIndex).reduce(0, +)
    }
}

struct StageView_Previews: PreviewProvider {
    static var previews: some View {
        StageView()
            .environmentObject(StageViewModel())
    }
}
