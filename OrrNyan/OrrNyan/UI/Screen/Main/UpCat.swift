//
//  UpCat.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/19.
//

import SwiftUI

struct UpCat: View {
	@State private var imagePositionY: CGFloat = UIScreen.height / 2.75
    @State private var isMovingUp = false
    //고양이가 멈추는 위치 잡기 위한 position
    @State private var stopPosition: CGFloat = UIScreen.height*0.9

    var body: some View {
        HStack {
            Button("UP") {
                isMovingUp = true
                moveImageUp()
            }
            Spacer()
            LottieView(filename: "LottieMainViewWalk")
                .frame(width:50, height:50)
                .rotationEffect(Angle(degrees: -90))
                .frame(width: UIScreen.width*0.079, height: UIScreen.height*0.079)
                .offset(y: imagePositionY)
                .animation(.easeInOut(duration: 1.0))
        }
    }

    private func moveImageUp() {
        guard isMovingUp else { return }
        if  imagePositionY > -230 {
            imagePositionY -= 5
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
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
