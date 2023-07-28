//
//  test.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/27.
//

import SwiftUI

struct test: View {
    @State private var imagePositionY: CGFloat = 300
    @State private var isMovingUp = false
    @State private var stopPosition: CGFloat = UIScreen.main.bounds.height * 0.9

    var body: some View {
        HStack {
            Button("올라가셈") {
                isMovingUp = true
                moveImageUp()
            }
            Spacer()
            LottieView(filename: isMovingUp ? "LottieMainViewWalk" : "OtherLottieImage")
                .frame(width: 50, height: 50)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: UIScreen.main.bounds.width * 0.079, height: UIScreen.main.bounds.height * 0.079)
                .offset(y: imagePositionY)
        }
    }

    private func moveImageUp() {
        guard isMovingUp else { return }
        if imagePositionY > -230 {
            imagePositionY -= 5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                moveImageUp() // 재귀적으로 계속 이동
            }
        } else {
            isMovingUp = false
        }
    }
}

//struct test_Previews: PreviewProvider {
//    static var previews: some View {
//        test()
//    }
//}
