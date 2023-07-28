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
            //랜드마크 이미지
            Image("StageSt0\(stageViewModel.selectedIndex + 1)")
                .resizable()
                .matchedGeometryEffect(id: "StageStImage0\(stageViewModel.selectedIndex + 1)", in: nameSpace)
                .aspectRatio(contentMode: .fit)
                .padding(.top,80)
                .frame(width: UIScreen.width*0.91, height: UIScreen.height*0.74)
                .shadow(radius: 5)
//            VStack{
//                MainTopView()
//                    .border(.red)
//                Spacer()
//                MainBottomView()
//                    .border(.red)
//            }.frame(height: UIScreen.height)
        }
    }
}

struct FrameUpAnimation: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    @State private var topImageOffset: CGFloat = UIScreen.height

    var body: some View {
        ZStack{
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_04")
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_05")
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_06")
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_01")
        }
        .scaledToFit()
        .offset( y: topImageOffset)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.0)) {
                topImageOffset = 0
            }
        }
    }
}

struct FrameSideInAnimation: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    //맨 처음에 화면 양 옆에 숨어있도록 뷰 위치 설정
    @State private var leftImageOffset: CGFloat = -300
    @State private var rightImageOffset: CGFloat = UIScreen.width + 300

    var body: some View {
        ZStack {
            //왼쪽에서 들어오는 이미지
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_02")
                .offset(x: leftImageOffset, y: 0 )
            //오른쪽에서 들어오는 이미지
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_03")
                .offset(x: rightImageOffset, y: 0)
        }
//        .resizable()
        .frame(height:UIScreen.height)
        .onAppear{
            withAnimation(Animation.easeInOut(duration: 1.0).delay(1.0)){
                // 이동 후 고정되는 위치 값
                leftImageOffset = 0
                rightImageOffset = 0
            }
        }
    }
}

struct BackOpacityAnimation:View{
    @State private var opacity: Double = 0.0
    @EnvironmentObject var stageViewModel: StageViewModel
    var body: some View{
        ZStack{
            Image("StageBg0\(stageViewModel.selectedIndex + 1)")
                .ignoresSafeArea()
                .opacity(opacity)
                .onAppear{
                    withAnimation(Animation.easeInOut(duration: 1.0).delay(1.3)){
                        opacity = 1.0
                    }
                }
        }
    }
}

struct MainParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        @Namespace var nameSpace
        MainParallaxView(nameSpace: nameSpace).environmentObject(StageViewModel())
    }
}
