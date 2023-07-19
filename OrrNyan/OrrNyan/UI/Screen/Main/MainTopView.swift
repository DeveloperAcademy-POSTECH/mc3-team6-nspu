//
//  MainTopView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainTopView: View {
    //MARK: - Variables
    @State var backDegree = 0.0
    @State var frontDegree = 90.0
    @State var isFlipped = false
    let durationAndDelay : CGFloat = 0.1
    
    //MARK: - View
    var body: some View {
        HStack{
            ZStack(alignment: .leading){
                StairCase(degree: $frontDegree)
                Stair(degree: $backDegree)
            }
            .onTapGesture {
                flipTitle()
            }
            Spacer()
            Rectangle()
                .frame(width:40, height:40)
                .foregroundColor(Color.gray)
                .cornerRadius(16)
                .overlay{
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .frame(width:25,height:25)
                }
        }
        .padding(.horizontal, 26)
//        .padding(25)
        .frame(width: UIScreen.main.bounds.width)
    }
    
    //MARK: - Flip Function
    func flipTitle() {
        print("flip!!!")
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        }else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
}


//MARK: - 층계
struct StairCase: View{
    @Binding var degree : Double
    @State var showingPopup = false
    var body: some View{
        VStack(alignment: .leading){
            Text("총 오른 층계")
                .font(.system(size:15,weight: .regular))
            Text("\(userFloorTestInstance.totalFloors) 층")
                .font(.system(size:38, weight: .bold))
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1, y: 0, z: 0))
    }
}
struct Stair: View{
    @Binding var degree : Double
    var body: some View{
        VStack(alignment: .leading){
            Text("총 오른 계단")
                .font(.system(size:15,weight: .regular))
            Text("\(userFloorTestInstance.totalFloors * 16) 계단")
                .font(.system(size:38, weight: .bold))
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 1, y: 0, z: 0))
    }
}



struct MainTopView_Previews: PreviewProvider {
    static var previews: some View {
        MainTopView()
    }
}
