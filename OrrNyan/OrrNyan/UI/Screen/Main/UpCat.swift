//
//  UpCat.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/19.
//

import SwiftUI

struct UpCat: View {
    @State private var imagePositionY: CGFloat = 300
    @State private var isMovingUp = false

    var body: some View {
        HStack {
            Button("올라가셈") {
                isMovingUp = true
                moveImageUp()
            }
            Spacer()
            Image("upCat")
                .resizable()
                .frame(width:30, height:45)
                .offset(y: imagePositionY)
        }
    }

    private func moveImageUp() {
        guard isMovingUp else { return }
        if  imagePositionY > -120 {
            imagePositionY -= 5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                moveImageUp() // 재귀적으로 계속 이동
            }
        } else {
                isMovingUp = false
        }
    }
}


struct UpCat_Previews: PreviewProvider {
    static var previews: some View {
        UpCat()
    }
}
