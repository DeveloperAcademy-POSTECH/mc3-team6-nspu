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
