//
//  FloorUpdatedAlert.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/30.
//

import SwiftUI

struct FloorUpdatedAlert: View {
	@State var isFloorUpdated : Bool = false // 여기가 업데이트 된 계단 가져옴
//    @State var userFloor = User.instance.userInfo
//    @State var stageInfo =  User.instance.userFloor//: StageInfo? = nil
//    @State var stages = Stages()
    var body: some View {
		
		VStack(spacing: 0){
			Text("대단해요!")
				.font(.system(size: 17, weight: .semibold))
			Text("잊지 않고 열심히 계단을 올랐군요?")
				.font(.system(size:13, weight: .regular))
				.padding(.top, 4)
			
			Divider().padding(EdgeInsets(top: 17, leading: 0, bottom: 12, trailing: 0))
				.foregroundColor(Color.Gray200)
			
			
			Button {
				print("여기에 함수!")
			} label: {
				Text("+ 12층")
					.font(.system(size: 17, weight: .bold))
					.foregroundColor(Color.Purple300)
					.frame(maxWidth: .infinity)
			}
		

		}
		.frame(maxWidth: .infinity)
		.padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))
		.background(.thinMaterial)
		.cornerRadius(14)
		.padding(.horizontal, 60)
		

		
		
		
    }
}

struct FloorUpdatedAlert_Previews: PreviewProvider {
    static var previews: some View {
        FloorUpdatedAlert()
    }
}
