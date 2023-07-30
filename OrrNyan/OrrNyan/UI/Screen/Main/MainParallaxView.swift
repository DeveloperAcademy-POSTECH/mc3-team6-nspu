//
//  MainParallaxView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainParallaxView: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    @StateObject var motionManager: MotionManager = .init()
	@State private var imagePositionY: CGFloat = 0
	@State private var stageStructureHeight: CGRect = .zero
	@State private var stageStructureWidth: CGRect = .zero
	@State private var catPositionY: CGFloat = .zero
	
	
//    var arr = ["1", "2", "3"]
    var nameSpace: Namespace.ID
    var body: some View {
		ZStack(alignment: .bottom){
            //            ForEach(arr, id: \.self){ item in
            //                Image(item)
            //            }
            BackOpacityAnimation()
                .offset(x: overlayOffsetX(offsetLimit: 500, value: 80), y:overlayOffsetY(offsetLimit: 0, value: 0))
            FrameSideInAnimation()
                .offset(x: overlayOffsetX(offsetLimit: 600, value: 30), y:overlayOffsetY(offsetLimit: 0, value: 0))
            FrameUpAnimation()
				.offset(x: overlayOffsetX(offsetLimit: 600, value: 80), y:overlayOffsetY(offsetLimit: 0, value: 0))

            //랜드마크 이미지
			
			
            Image("StageSt0\(stageViewModel.selectedIndex + 1)")
                .resizable()
                .matchedGeometryEffect(id: "StageStImage0\(stageViewModel.selectedIndex + 1)", in: nameSpace)
                .aspectRatio(contentMode: .fit)
                .frame(height: UIScreen.height*0.736)
//				.offset(x: overlayOffsetX(offsetLimit: 600, value: 80), y:overlayOffsetY(offsetLimit: 10, value: 2))
				.modifier(GetHeightModifier())
				.padding(.bottom, DeviceSize.width > DeviceSize.iPhoneSE  ? 94 : 45)
                .border(.red)
				.onPreferenceChange(ContentRectSize.self) { rects in
					self.stageStructureWidth = rects
					self.stageStructureHeight = rects
				}
				.overlay(alignment:.trailing){
					UpCat()
						.frame(width: UIScreen.width)
						.position(x:stageStructureWidth.width - (DeviceSize.width > DeviceSize.iPhoneSE  ? 14 : -22), y: catPositionY )
				}
			
			Button {
				withAnimation(.spring(response: 3, dampingFraction: 0.8)){
					stageStructureHeight = .zero
					
						//버튼 눌렀을때, 고양이 높이 값을 수정하는 코드는 여기입니다!
					catPositionY = stageStructureHeight.height + 20
				}
			} label: {
				Text("UPUPUPUPUPUP")
			}
			.padding(.bottom, 100)

			
		
			
        }
		.onAppear(perform: motionManager.detectMotion)
		.onAppear{
			catPositionY = stageStructureHeight.height
		}
		
        .onDisappear(perform: motionManager.stopMotionUpdates)


    }
	
	func overlayOffsetX(offsetLimit:CGFloat, value : CGFloat) -> CGFloat {
		let offset = motionManager.xValue * value
		if offset > 0  {
			return offset > offsetLimit ? offsetLimit : offset
		}
		return -offset > offsetLimit ? -offsetLimit : offset
	}
	
	func overlayOffsetY(offsetLimit:CGFloat, value : CGFloat) -> CGFloat {
		let offset = motionManager.yValue * value
		if offset > 0  {
			return offset > offsetLimit ? offsetLimit : offset
		}
		return -offset > offsetLimit ? -offsetLimit : offset
	}
	
}

struct FrameUpAnimation: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    @State private var topImageOffset: CGFloat = UIScreen.height

    var body: some View {
        ZStack{
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_05")
				.resizable()
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_06")
				.resizable()
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_01")
				.resizable()
        }
		
        .scaledToFit()
		.frame(height: UIScreen.height)
		.border(.blue)
        .offset(y: topImageOffset)
        .onAppear {
            withAnimation(Animation.spring(response: 1.0, dampingFraction: 0.92)) {
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
                .resizable()
				.aspectRatio(contentMode: .fit)
                .frame(height:UIScreen.height)
                .offset(x: leftImageOffset, y: 0 )
            //오른쪽에서 들어오는 이미지
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_03")
                .resizable()
				.aspectRatio(contentMode: .fit)
                .frame(height:UIScreen.height)
                .offset(x: rightImageOffset, y: 0)
        }
        .onAppear{
            withAnimation(Animation.spring(response:1.8, dampingFraction: 0.92)){
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
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(height: UIScreen.height)
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_04")
				.frame(height: UIScreen.height)
				.aspectRatio(contentMode: .fit)
				.frame(height: UIScreen.height)
        }
        .ignoresSafeArea()
        .opacity(opacity)
        .onAppear{
            withAnimation(Animation.spring(response:1.5, dampingFraction: 0.92)){
                opacity = 1.0
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
