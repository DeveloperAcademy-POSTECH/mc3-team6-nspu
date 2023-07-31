//
//  BadgePopupView.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/27.
//

import SwiftUI

struct BadgePopupView: View {
	@State var userFloor = User.instance.userInfo
	@State var stageInfo =  User.instance.userFloor//: StageInfo? = nil
	@State var stages = Stages()
	@Binding var showingPopupIndex : Int
	@Binding var isSowingPopup : Bool
	@Binding var degree : Double
	@GestureState private var dragDegree: CGFloat = 0
	
	var body: some View {
		
		VStack(spacing: 0){
			Image(systemName: "xmark.circle.fill")
				.resizable()
				.frame(width: 30, height: 30)
				.foregroundStyle(Color.Gray200, Color.White100)
				.frame(maxWidth:.infinity, alignment:.trailing)
				.padding(.trailing, 20)
				.onTapGesture {
					degree = 0
					withAnimation(.spring(response: 0.6, dampingFraction: 0.6)){
						isSowingPopup.toggle()
					}
				}
			
			Image("Badge0\(showingPopupIndex)_Detail")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(maxWidth: .infinity)
				.shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 4)
				.padding(.horizontal, 50)
				.padding(.top, 12)
				.rotation3DEffect(.degrees(degree + dragDegree), axis: (x:0, y:1, z:0))
				.gesture(
					  DragGesture()
						  .updating($dragDegree) { value, state, _ in
							  state = value.translation.width
						  }
						  .onEnded { value in
							  // 가속도를 측정
							  let velocity = value.predictedEndTranslation.width
							  
							  // 측정한 가속도 값에 따른 Degree값을 도출
							  let finalDegree = degree + Double(dragDegree) + Double(velocity)
							  
							  // 위에서 구한 값들에 애니메이션 효과를 줌
							  // 가속도 값이 120보다 낮을 경우, degree에 가장 가까운 180 배수 숫자를 구해냄
							  withAnimation(.interpolatingSpring(stiffness: 50, damping: 50)) {
								  if abs(velocity) > 120  {
									  // 가장 가까운 180의 배수로 보정
									  let adjustedDegree = 180 * round(finalDegree / 180)
									  degree = adjustedDegree
								  }
							  }
							  if abs(velocity) < 120  {
								  
								  degree = finalDegree
							  }
						  }
				  )

			
			Text("\(stages.StageInfos[showingPopupIndex - 1].stageLocation)")
				.font(.pretendard(size: 16, .bold))
				.foregroundColor(Color.Black100)
				.padding(.top, 10 )
			
			Text("\(stages.StageInfos[showingPopupIndex - 1].stageName)")
				.font(.pretendard(size: 24, .extraBold))
				.foregroundColor(Color.Black300)
				.padding(.top, 4)
				.padding(.bottom, 20)
			
			
			VStack(alignment: .leading, spacing: 2) {
				Text("총 층계")
					.font(.pretendard(size: 13, .medium))
				Text("\(stages.StageInfos[showingPopupIndex - 1].stageFloors)층")
					.font(.pretendard(size: 24, .bold))
					.foregroundColor(Color.Purple300)
				
				Divider().padding(.vertical, 7)
				
				Text("높이")
					.font(.pretendard(size: 13, .medium))
				Text("\(stages.StageInfos[showingPopupIndex - 1].stageHeight)m")
					.font(.pretendard(size: 24, .bold))
					.foregroundColor(Color.Purple300)
				
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading, 16)
			.padding(.vertical, 13)
			.background(Color.White300)
			.cornerRadius(16)
			.padding(.horizontal, 20)
			
		}
		.frame(width: UIScreen.main.bounds.width / 1.12)
		.padding(.vertical, 14)
		.background(.ultraThickMaterial)
		.cornerRadius(16)
		.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
		
	}
}

struct BadgePopupView_Previews: PreviewProvider {
	static var previews: some View {
		BadgePopupView(showingPopupIndex: .constant(1), isSowingPopup: .constant(false), degree: .constant(0))
	}
}
