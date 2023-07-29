//
//  GetBadgeAnimation.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/28.
//

import SwiftUI

struct GetBadgeAnimation: View {
	@EnvironmentObject var stageViewModel: StageViewModel
	@State var isButtonShow : Bool = false
	@State var secondAnimation : Bool = false
	@State var degree : Double = 0
	@Namespace var namespace
	@Namespace var namespace2
	
	var body: some View {
		ZStack{
			if !isButtonShow {
				Button {
					withAnimation(.spring(response: 0.8, dampingFraction: 0.8)){
						isButtonShow.toggle()
					}
					withAnimation(.easeOut(duration: 1.5)){
						degree = 1800
					}
					print("hello")
				} label: {
					Text("완료됐다냥!")
				}
			}
	
			if isButtonShow &&  !secondAnimation {
				Image("Badge01_Detail")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.matchedGeometryEffect(id: "badgeSpin", in: namespace)
					.matchedGeometryEffect(id: "badgeSpin2", in: namespace2)
					.rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
					.frame(width: 250)
					.onTapGesture {
						secondAnimation = true
						print("gd")
					}
					.border(.red)
				
			} else {
				Image("Badge01_Detail")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.matchedGeometryEffect(id: "badgeSpin", in: namespace)
					.rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
					.offset(y: 600)
					.frame(width: 80)
			}
			
			if secondAnimation {
				Image("Badge01_Detail")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.matchedGeometryEffect(id: "badgeSpin2", in: namespace2)
					.rotation3DEffect(.degrees(degree), axis: (x: 0, y: 1, z: 0))
//					.offset(x: -130 , y:350)
					.frame(width: 30)
			}
			
		}
		
	}
}

struct GetBadgeAnimation_Previews: PreviewProvider {
	static var previews: some View {
		GetBadgeAnimation()
	}
}
