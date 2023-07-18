//
//  ComponentView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("총 오른 층계")
                    .font(.system(size: 12))
                Text("123층")
                    .font(.system(size: 32, weight: .bold))
					.font(.custom("Pretendard-Light", size: 20))
					.font(.pretendard(size: 20, .extraLight))
				
//				Text("12gkgk하하 안녕하세요 취권!123")
//					.font(.pretendard(size: 20, .bold))
//					.font(.pretendard(size:30, .regular))
            }
            Spacer()
            Image(systemName: "gearshape.circle.fill")
                .font(.system(size: 32))
        }
        .padding(.horizontal, 30)
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
