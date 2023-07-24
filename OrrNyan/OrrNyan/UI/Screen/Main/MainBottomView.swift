//
//  MainBottomView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/16.
//

import SwiftUI

struct MainBottomView: View {
    var body: some View {
        // MARK: - myPage NavigationLink로 할 지 논의
        HStack {
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: "arrow.turn.up.left")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.95, green: 0.95, blue: 0.95))
                    .shadow(radius: 4)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background(.thinMaterial)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LinearGradient(colors: [.White200, .White200.opacity(0)], startPoint: .leading, endPoint: .topTrailing), lineWidth: 1.5)
            }
            Spacer()
        }
        .padding(.leading, 21)
        .padding(.top, 20)
        .padding(.bottom, 34)
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct MainBottomView_Previews: PreviewProvider {
    static var previews: some View {
        MainBottomView()
    }
}
