//
//  MainParallaxView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainParallaxView: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    var nameSpace: Namespace.ID
    var body: some View {
        ZStack{
            FrameInAnimation()
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_01")
//                Image("StageEm0\(stageViewModel.selectedIndex + 1)_02")
//                Image("StageEm0\(stageViewModel.selectedIndex + 1)_03")
                Image("StageEm0\(stageViewModel.selectedIndex + 1)_04")
                Image("StageSt0\(stageViewModel.selectedIndex + 1)")
                    .resizable()
                    .matchedGeometryEffect(id: "StageStImage0\(stageViewModel.selectedIndex + 1)", in: nameSpace)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width*1.27)
                    .shadow(radius: 5)

        }
    }
}

struct FrameInAnimation: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    //맨 처음에 화면 양 옆에 숨어있도록 뷰 위치 설정
    @State private var leftImageOffset: CGFloat = -300
    @State private var rightImageOffset: CGFloat = UIScreen.main.bounds.width + 300

    var body: some View {
        ZStack {
            Image("StageBg01").ignoresSafeArea()
            //왼쪽에서 들어오는 이미지
            Image("StageEm01_02")
                .resizable()
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.width)*1.0, height: (UIScreen.main.bounds.height) * 1.0)
                .offset(x: leftImageOffset, y: 0 )
                .animation(.easeInOut(duration: 1.5))
            //오른쪽에서 들어오는 이미지
            Image("StageEm01_03")
                .resizable()
                .scaledToFit()
                .frame(width: (UIScreen.main.bounds.width)*2, height: (UIScreen.main.bounds.height)*2)
                .offset(x: rightImageOffset, y: 0)
                .animation(.easeInOut(duration: 1.5))
        }
        .onAppear {
            // 이동 후 고정되는 위치 값
            leftImageOffset = -10
            rightImageOffset = 10
        }
    }
}

struct MainParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var nameSpace
        MainParallaxView(nameSpace: nameSpace).environmentObject(StageViewModel())
    }
}
