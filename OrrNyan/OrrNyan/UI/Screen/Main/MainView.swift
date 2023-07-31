//
//  MainView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var stageViewModel: StageViewModel
	@EnvironmentObject var appFirstLaunch : AppFirstLaunch
    var nameSpace: Namespace.ID
    var body: some View {
        ZStack {
			MainParallaxView(nameSpace: nameSpace)

            VStack {
                MainTopView()
                    .ignoresSafeArea()
//                    .border(.red)
                Spacer()
                MainBottomView()
                    .onTapGesture {
                        stageViewModel.isMainDisplayed = false
                }
            }
            .frame(height: UIScreen.height)
//            UpCat()
//                .frame(width: UIScreen.width)
            
        }
		.onAppear{
			appFirstLaunch.isFirstlaunch = false
			
		}
        // 이거 없으면 옆으로 옮겨짐->밀리지 말고 뷰 안에서 작용하도록 함
        .frame(height: UIScreen.height)
    }
}

 struct MainView_Previews: PreviewProvider {
     @Namespace static var namespace
    static var previews: some View {
        MainView(nameSpace: namespace)
            .environmentObject(StageViewModel())
    }
 }
