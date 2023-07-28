//
//  BadgePopupView.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/27.
//

import SwiftUI

struct BadgePopupView: View {
	@State var userFloor : UserFloor? = nil
	@State var stageInfo : StageInfo? = nil
	@Binding var showingPopupIndex : Int
	@Binding var isSowingPopup : Bool
	@Binding var degree : Double
	
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
				.rotation3DEffect(.degrees(degree), axis: (x:0, y:1, z:0))
			
			Text("대한민국")
				.font(.pretendard(size: 16, .bold))
				.foregroundColor(Color.Black100)
				.padding(.top, 10 )
			
			Text("석가탑")
				.font(.pretendard(size: 24, .extraBold))
				.foregroundColor(Color.Black300)
				.padding(.top, 4)
				.padding(.bottom, 20)
			
			
			VStack(alignment: .leading, spacing: 2) {
				Text("총 층계")
					.font(.pretendard(size: 13, .medium))
				Text("\(stageInfo?.stageFloors ?? 3)층")
					.font(.pretendard(size: 24, .bold))
					.foregroundColor(Color.Purple300)
				
				Divider().padding(.vertical, 7)
				
				Text("높이")
					.font(.pretendard(size: 13, .medium))
				Text("\(stageInfo?.stageHeight ?? 20)m")
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
