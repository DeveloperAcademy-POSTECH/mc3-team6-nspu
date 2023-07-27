//
//  testView.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/23.
//

import SwiftUI

struct MyPageView: View {
	@State var user : User? = nil
	@State var userFloor : UserFloor? = nil
	@State var popupIndex : Int = 1
	@State var isShowingPopup : Bool = false
	@State var degree : Double = 0
	@Namespace var namespace
	
	//테스트성 코드입니다.
	var userBadges =  UserBadge(stageCompleteArray: [true, true, false])
	
	//3xn 그리드 템플릿
	let columns: [GridItem] = [
		GridItem(.flexible(), alignment: .center),
		GridItem(.flexible(), alignment: .center),
		GridItem(.flexible(), alignment: .center)
	]
	
	var body: some View {
		NavigationStack {
			
			ZStack {
				List{
					// MARK: - 01_로티영역
					Section(header: header(title: "").padding(.top, 80)) {
						myCharacter(animation: "LottieMypageViewSleep", nickName: user?.nickName ?? "제트의냥이", date: Date())
					}
					.listRowInsets(EdgeInsets())
					
					
					
					
					// MARK: - 02_내기록
					Section(header: header(title: "내 기록")) {
						myRecord(title: "오늘 오른 층계", data: userFloor?.dailyFloors ?? 0, unit: "층")
						myRecord(title: "총 오른 층계", data: userFloor?.totalFloors ?? 0, unit: "층")
						myRecord(title: "총 오른 계단", data: userFloor?.totalFloors ?? 0, unit: "계단")
						myRecord(title: "총 오른 높이", data: userFloor?.totalFloors ?? 0, unit: "m")
					}.listRowInsets(EdgeInsets())
					
					
					
					// MARK: - 03_Badge
					Section(header : header(title: "배지")) {
						myBadge()
					}.listRowInsets(EdgeInsets())
					
				}//list end
				.listStyle(.insetGrouped)
				.padding(.horizontal, 10)
				.background(Color.White200)
				
				
				
				// MARK: - 애니메이션
				if isShowingPopup {
					backgroundCover()

					BadgePopupView(showingPopupIndex: $popupIndex, isSowingPopup: $isShowingPopup, degree: $degree)
						.matchedGeometryEffect(id: "BadgePopup", in: namespace)
				} else {
					BadgePopupView(showingPopupIndex: $popupIndex, isSowingPopup: $isShowingPopup, degree: $degree)
						.matchedGeometryEffect(id: "BadgePopup", in: namespace)
						.offset(y:600)
						.frame(width: 0, height: 0)
						.border(.red)
				}
			}
			.ignoresSafeArea()
			.background(Color.White200)
		}
	}
	
	
	
	///Header Title
	private func header(title:String) -> some View {
		Text(title)
			.font(.pretendard(size: 20, .semiBold))
			.foregroundColor(Color.Black300)
			.padding(.bottom, 10)
			.padding(.top, 15)
			.listRowInsets(EdgeInsets())
	}
	
	
	
	///Background Disable
	private func backgroundCover() -> some View {
		Rectangle()
			.opacity(0.6)
	}
	
	
	
	///01_로띠 영역 컴포넌트
	private func myCharacter(animation : String, nickName: String, date: Date) -> some View {
		LottieView(filename: animation)
			.frame(maxWidth: .infinity)
			.frame(height:230)
			.overlay(alignment:.bottom){
				VStack(spacing:8){
					Text(nickName)
						.font(.pretendard(size:19, .bold))
						.foregroundColor(Color.Purple300)
					
					HStack(spacing:2){
						Text("\(Image(systemName: "pawprint.fill"))")
							.foregroundColor(Color.Purple100)
							.font(.system(size:12))
						
						Text("\(date, style: .date)")
							.font(.pretendard(size: 13, .semiBold))
					}
					.padding(.horizontal, 10)
					.padding(.vertical, 5)
					.background(Color.White200)
					.cornerRadius(7)
					.shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 2)
				}
				.padding(.bottom, 25)
			}
	}
	
	
	
	///02_내 기록 영역 컴포넌트
	private func myRecord(title: String, data: Int, unit : String) -> some View {
		VStack(alignment: .leading) {
			Text(title)
				.font(.pretendard(size: 13, .medium))
			Text("\(data)\(unit)")
				.font(.pretendard(size: 24, .bold))
				.foregroundColor(Color.Purple300)
		}
		.padding(EdgeInsets(top: 15, leading: 16, bottom: 10, trailing: 0))
	}
	
	
	
	///03_내 배지 영역 컴포넌트
	private func myBadge() -> some View {
		LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
			ForEach(0 ..< (userBadges.stageCompleteArray.count), id: \.self) { userBadge in
				if userBadges.stageCompleteArray[userBadge] {
					Image("Badge0\(userBadge + 1)_abled")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 80, height: 80)
						.onTapGesture {
							withAnimation(.spring(response: 0.6, dampingFraction: 0.6)){
								popupIndex = userBadge + 1
								isShowingPopup.toggle()
							}
							
							withAnimation(.easeOut(duration: 1.5)){
								degree = 1080
							}
						}
				} else {
					Image("Badge0\(userBadge + 1)_Disabled")
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 80, height: 80)
				}
			}
		}
		.padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 25))
	}
	
	
}

struct MyPageView_Previews: PreviewProvider {
	static var previews: some View {
		MyPageView()
			.preferredColorScheme(.light)
	}
}
