//
//  MainView.swift
//  OrrNyan
//
//  Created by 박상원 on 2023/07/12.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var stageViewModel: StageViewModel
    @State var isFloorUpdated = false

    var nameSpace: Namespace.ID
    
    var body: some View {
        ZStack {
			MainParallaxView(nameSpace: nameSpace)
            VStack {
                MainTopView()
                    .ignoresSafeArea()
                Spacer()
                MainBottomView()
                    .onTapGesture {
                        stageViewModel.isMainDisplayed = false
                }
            }
            .frame(height: UIScreen.height)
            if isFloorUpdated {
                FloorUpdatedAlert(isFloorUpdated: $isFloorUpdated)
            }
        }
        .frame(height: UIScreen.height)
        .onReceive(NotificationCenter.default.publisher(for: .isFloorsChanged).receive(on: RunLoop.main).eraseToAnyPublisher()){ newValue in
            
            guard let isChanged = newValue.userInfo?.first?.value as? Bool else {return}
            self.isFloorUpdated = isChanged
        }
        .onAppear() {
            self.isFloorUpdated = User.instance.isFloorsChanged
        }
    }
}

 struct MainView_Previews: PreviewProvider {
     @Namespace static var namespace
    static var previews: some View {
        MainView(nameSpace: namespace)
            .environmentObject(StageViewModel())
    }
 }
