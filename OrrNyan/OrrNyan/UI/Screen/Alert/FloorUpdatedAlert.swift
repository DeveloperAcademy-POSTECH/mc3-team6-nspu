//
//  FloorUpdatedAlert.swift
//  OrrNyan
//
//  Created by YouiHyon Kim on 2023/07/30.
//

import SwiftUI

struct FloorUpdatedAlert: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
	@Binding var isFloorUpdated : Bool // 여기가 업데이트 된 계단 가져옴
    @State var increasedFloors = 0

    var body: some View {
        ZStack {
            backgroundCover()
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                Text("대단해요!")
                    .font(.system(size: 17, weight: .semibold))
                Text("잊지 않고 열심히 계단을 올랐군요?")
                    .font(.system(size:13, weight: .regular))
                    .padding(.top, 4)
                
                Divider().padding(EdgeInsets(top: 17, leading: 0, bottom: 12, trailing: 0))
                    .foregroundColor(Color.Gray200)
                
                Button {
                    Task {
                        guard let lastVisitData = try await firebaseManager.readRecentUserFloor() else {return}
                        print("ContentView lastVisitdata = \(lastVisitData)")
                        let now = Date()
                        // 오늘 이면
                        if User.instance.isToday {
                            if var userFloorTemp = User.instance.getUserFloorTemp() {
                                userFloorTemp.date = now
                                try await firebaseManager.updateUserFloor(oldData: lastVisitData, newData: userFloorTemp)
                                
                                guard let userFloorTempLast = try await firebaseManager.readRecentUserFloor() else {return}
                                User.instance.saveFloorsToUserDefaults(userFloorTempLast)
                                // 앱 실행시 항상 가지고 있어야하는 유저플로어에도 반영
                                User.instance.userFloor = userFloorTempLast
                            }
                        }
                        
                        // 오늘이 아니면
                        else if !User.instance.isToday{
                            if let userFloorTemp = User.instance.getUserFloorTemp() {
                                try await firebaseManager.updateUserFloor(oldData: lastVisitData, newData: userFloorTemp)
                            }
                            if let userFloorTempArray = User.instance.getUserFloorTempArray() {
                                for temp in userFloorTempArray {
                                    firebaseManager.createUserFloor(userFloor: temp)
                                }
                                guard let userFloorTempLast = try await firebaseManager.readRecentUserFloor() else {return}
                                User.instance.saveFloorsToUserDefaults(userFloorTempLast)
                                // 앱 실행시 항상 가지고 있어야하는 유저플로어에도 반영
                                User.instance.userFloor = userFloorTempLast
                            }
                        }
                    }
                    User.instance.isFloorsChanged = false
                } label: {
                    Text("+ \(increasedFloors)층")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color.Purple300)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 12, trailing: 0))
            .background(.thinMaterial)
            .cornerRadius(14)
            .padding(.horizontal, 60)
            .border(.red)
            .onAppear() {
                self.increasedFloors = User.instance.increasedFloorsCount
            }
        }
        

    }
    
    ///Background Disable
    private func backgroundCover() -> some View {
        Rectangle()
            .opacity(0.6)
    }
    
}

