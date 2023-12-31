//
//  StageBottomView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/26.
//

import SwiftUI

struct StageBottomView: View {
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "person.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.Purple100)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 2, y: 4)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LinearGradient(colors: [.White200, .White200.opacity(0)], startPoint: .leading, endPoint: .topTrailing), lineWidth: 1.5)
            }
            Spacer()
        }
        .padding(.leading, 21)
        .padding(.top, 20)
        .padding(.bottom, 34)
        .frame(width: UIScreen.width)
    }
}

struct StageBottomView_Previews: PreviewProvider {
    static var previews: some View {
        StageBottomView()
    }
}
