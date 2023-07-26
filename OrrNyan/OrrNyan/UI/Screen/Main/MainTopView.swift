//
//  MainTopView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainTopView: View {
    // MARK: - Variables

    @State var backDegree = 0.0
    @State var frontDegree = 90.0
    @State var isFlipped = false
    @EnvironmentObject var stageViewModel: StageViewModel
    let durationAndDelay: CGFloat = 0.1

    // MARK: - View

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                StairCase(degree: $frontDegree)
//                    .environmentObject(StageViewModel())
                Stair(degree: $backDegree)
            }
            .onTapGesture {
                flipTitle()
            }
            Spacer()
            if stageViewModel.isMainDisplayed {
                VStack(alignment: .center, spacing: 10) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.White200)
                        .shadow(radius: 4)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(.thinMaterial)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(LinearGradient(colors: [.White200, .White200.opacity(0)], startPoint: .leading, endPoint: .topTrailing), lineWidth: 1.5)
                }
            }
            else {
                VStack {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.Purple100)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
                .background(.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.25), radius: 10, y: 4)
            }
        }
        .padding(.top, 65)
        .padding(.horizontal, 26)
        .frame(width: UIScreen.main.bounds.width)
    }

    // MARK: - Flip Function

    func flipTitle() {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree = 0
            }
        }
    }
}

// MARK: - 층계

struct StairCase: View {
    @Binding var degree: Double
    @State var showingPopup = false
    @EnvironmentObject var stageViewModel: StageViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("총 오른 층계")
                .font(.pretendard(size: 18, .semiBold))
                .foregroundColor(stageViewModel.isMainDisplayed ? .White200 : .Black100)
            Text("\(userFloorTestInstance.totalFloors)층")
                .font(.pretendard(size: 40, .semiBold))
                .foregroundColor(.Purple300)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1, y: 0, z: 0))
    }
}

struct Stair: View {
    @Binding var degree: Double
    @EnvironmentObject var stageViewModel: StageViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("총 오른 계단")
                .font(.pretendard(size: 18, .semiBold))
                .foregroundColor(stageViewModel.isMainDisplayed ? .White200 : .Black100)
            Text("\(userFloorTestInstance.totalFloors * 16)계단")
                .font(.pretendard(size: 40, .semiBold))
                .foregroundColor(.Purple300)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1, y: 0, z: 0))
    }
}

struct MainTopView_Previews: PreviewProvider {
    static var previews: some View {
        MainTopView()
            .environmentObject(StageViewModel())
    }
}
