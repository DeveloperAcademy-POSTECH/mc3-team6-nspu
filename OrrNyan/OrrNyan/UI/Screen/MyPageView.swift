//
//  testView.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/23.
//

import SwiftUI

struct MyPageView: View {
	@State var userFloor : UserFloor? = nil
	
	//테스트성 코드입니다.
	var userBadges =  UserBadge(stageCompleteArray: [false, true, false])

	//3xn 그리드 템플릿
	let columns: [GridItem] = [
		GridItem(.flexible(), alignment: .center),
		GridItem(.flexible(), alignment: .center),
		GridItem(.flexible(), alignment: .center)
	]
	
	var body: some View {
		ZStack {
			List{
				// MARK: - 01_로티영역
				Section {
					LottieView(filename: "LottieMypageViewSleep")
						.frame(maxWidth: .infinity)
						.frame(height:230)
						.overlay(alignment:.bottom){
							VStack(spacing:8){
								Text("제트의꿀잠")
									.font(.pretendard(size:19, .bold))
									.foregroundColor(Color.Purple300)
								
								HStack(spacing:2){
									Text("\(Image(systemName: "pawprint.fill"))")
										.foregroundColor(Color.Purple100)
										.font(.system(size:12))
									
									Text("1891일")
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
				}.listRowInsets(EdgeInsets())
				
				
				// MARK: - 02_내기록
				Section {
					VStack(alignment: .leading) {
						Text("오늘 오른 층계")
							.font(.pretendard(size: 13, .medium))
						Text("\(userFloor?.dailyFloors ?? 12)층")
							.font(.pretendard(size: 24, .bold))
							.foregroundColor(Color.Purple300)
					}
					.padding(EdgeInsets(top: 15, leading: 16, bottom: 10, trailing: 0))
					
					VStack(alignment: .leading) {
						Text("총 오른 층계")
							.font(.pretendard(size: 13, .medium))
						Text("\(userFloor?.dailyFloors ?? 847)층")
							.font(.pretendard(size: 24, .bold))
							.foregroundColor(Color.Purple300)
					}.padding(EdgeInsets(top: 15, leading: 16, bottom: 10, trailing: 0))
					
					VStack(alignment: .leading) {
						Text("총 오른 계단").font(.pretendard(size: 13, .medium))
						Text("\(userFloor?.dailyFloors ?? 13482)계단")
							.font(.pretendard(size: 24, .bold))
							.foregroundColor(Color.Purple300)
					}.padding(EdgeInsets(top: 15, leading: 16, bottom: 10, trailing: 0))
					
					VStack(alignment: .leading) {
						Text("총 오른 높이")
							.font(.pretendard(size: 13, .medium))
						Text("\(userFloor?.dailyFloors ?? 789)m")
							.font(.pretendard(size: 24, .bold))
							.foregroundColor(Color.Purple300)
					}.padding(EdgeInsets(top: 15, leading: 16, bottom: 10, trailing: 0))
				} header: {
					Text("내기록")
						.font(.pretendard(size: 20, .semiBold))
					//						.listRowInsets(EdgeInsets())
						.foregroundColor(Color.Black300)
						.padding(.bottom, 10)
				}
				.listRowInsets(EdgeInsets())
				
				
				
				// MARK: - 03_Badge
				Section {
					LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
						ForEach(0 ..< (userBadges.stageCompleteArray.count + 3), id: \.self) { userBadge in
							Circle()
								.frame(width: 80, height: 80)
								.foregroundColor(Color.Black300)
						}
					}
					.padding(EdgeInsets(top: 25, leading: 25, bottom: 25, trailing: 25))
				} header: {
					Text("배찌")
						.font(.pretendard(size: 20, .semiBold))
						.foregroundColor(Color.Black300)
						.padding(.bottom, 10)
				}.listRowInsets(EdgeInsets())
				
				
			}.listStyle(.insetGrouped)
				.padding(.horizontal, 10)
		}.ignoresSafeArea()
			.background(Color.White200)
		
		
	}
}

struct MyPageView_Previews: PreviewProvider {
	static var previews: some View {
		MyPageView()
	}
}
