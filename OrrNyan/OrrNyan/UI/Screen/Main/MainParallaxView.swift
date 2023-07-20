//
//  MainParallaxView.swift
//  OrrNyan
//
//  Created by qwd on 2023/07/18.
//

import SwiftUI

struct MainParallaxView: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    var nameSpace: Namespace.ID
    var body: some View {
        ZStack(alignment: .top){
            Image("StageEm0\(stageViewModel.selectedIndex + 1)_01")
                Image("StageEm0\(stageViewModel.selectedIndex + 1)_02")
                Image("StageEm0\(stageViewModel.selectedIndex + 1)_03")
                Image("StageEm0\(stageViewModel.selectedIndex + 1)_04")
                Image("StageSt0\(stageViewModel.selectedIndex + 1)")
                    .resizable()
                    .matchedGeometryEffect(id: "StageStImage0\(stageViewModel.selectedIndex + 1)", in: nameSpace)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width*1.27)
                    .shadow(radius: 5)

        }
    }
}
//
//struct MainParallaxView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainParallaxView()
//    }
//}
