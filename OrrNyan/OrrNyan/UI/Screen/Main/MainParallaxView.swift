//
//  MainParallaxView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainParallaxView: View {
    @EnvironmentObject var stageViewModel: StageViewModel
//    var arr = ["1", "2", "3"]
    var nameSpace: Namespace.ID
    var body: some View {
        ZStack{
            //            ForEach(arr, id: \.self){ item in
            //                Image(item)
            //            }
            BackOpacityAnimation()
            FrameSideInAnimation()
            FrameUpAnimation()
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_04")
            //랜드마크 이미지
            Image("StageSt0\(stageViewModel.selectedIndex + 1)")
                .resizable()
                .matchedGeometryEffect(id: "StageStImage0\(stageViewModel.selectedIndex + 1)", in: nameSpace)
                .aspectRatio(contentMode: .fit)
                .padding(.top,20)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.8)
                .shadow(radius: 5)
                .border(.red)

        }
    }
}

struct FrameUpAnimation: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    @State private var bottomImageOffset: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        Image("StageEm0\(stageViewModel.selectedIndex + 1 )_01") // 새로운 이미지 파일의 이름으로 변경하세요
            .scaledToFit()
            .offset( y: bottomImageOffset)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.5)) {
                    bottomImageOffset = 0
                }
            }
    }
}

struct FrameSideInAnimation: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    //맨 처음에 화면 양 옆에 숨어있도록 뷰 위치 설정
    @State private var leftImageOffset: CGFloat = -300
    @State private var rightImageOffset: CGFloat = UIScreen.main.bounds.width + 300

    var body: some View {
        ZStack {
            //왼쪽에서 들어오는 이미지
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_02")
                .resizable()
                .scaledToFill()
                .frame(width: (UIScreen.main.bounds.width)*1.0, height: (UIScreen.main.bounds.height) * 1.0)
                .offset(x: leftImageOffset, y: 0 )
            //오른쪽에서 들어오는 이미지
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_03")
                .resizable()
                .scaledToFit()
                .frame(width: (UIScreen.main.bounds.width)*2, height: (UIScreen.main.bounds.height)*2)
                .offset(x: rightImageOffset, y: 0)
        }
        .onAppear{
            withAnimation(Animation.easeInOut(duration: 1.5)){
                // 이동 후 고정되는 위치 값
                leftImageOffset = -10
                rightImageOffset = 10
            }
        }
    }
}

struct BackOpacityAnimation:View{
    @EnvironmentObject var stageViewModel: StageViewModel
    var body: some View{
        ZStack{
            Image("StageBg0\(stageViewModel.selectedIndex + 1)").ignoresSafeArea()
        }
    }
}

struct MainParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var nameSpace
        MainParallaxView(nameSpace: nameSpace).environmentObject(StageViewModel())
    }
}
