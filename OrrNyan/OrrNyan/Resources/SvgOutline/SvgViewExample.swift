//
//  SvgViewExample.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/25.
//

import SwiftUI

struct SvgViewExample: View {
    var body: some View {
		let stageStSvgs: [AnyView] = [
			AnyView(StageStSvg01()),
			AnyView(StageStSvg02()),
			AnyView(StageStSvg03())
		]

		ZStack{
			TabView{
				ForEach(0..<3) { index in
					Image("StageSt0\(index + 1)")
						.resizable()
						.aspectRatio(contentMode: .fit) // 이미지 크기를 조정합니다
						.overlay{
							stageStSvgs[index]
								.opacity(0.01)
								.foregroundColor(Color.red)
								.onTapGesture {
									print("Image tapped!\(index)")
								}
						}
				}
				
			}
			.tabViewStyle(.page)

		}
    }
}

struct SvgViewExample_Previews: PreviewProvider {
    static var previews: some View {
        SvgViewExample()
    }
}
