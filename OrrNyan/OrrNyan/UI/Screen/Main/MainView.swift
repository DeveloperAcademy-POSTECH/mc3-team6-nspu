//
//  MainView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//


import SwiftUI
struct MainView: View{
    @EnvironmentObject var stageViewModel: StageViewModel
    var nameSpace: Namespace.ID
    var body: some View{
        ZStack{
            MainParallaxView(nameSpace: nameSpace)
//                .frame(maxWidth: .infinity)
            VStack{
                MainTopView()
                Spacer()
                    .frame(height:650)
                    MainBottomView()
                        .onTapGesture {
                            stageViewModel.isMainDisplayed = false
                    }                    
            }
            UpCat()
                .frame(width: UIScreen.main.bounds.width)

        }
        .background(Image("StageBg01").resizable())
        .ignoresSafeArea()
        //이거 없으면 옆으로 옮겨짐->밀리지 말고 뷰 안에서 작용하도록 함
        .frame(height: UIScreen.main.bounds.height)
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
