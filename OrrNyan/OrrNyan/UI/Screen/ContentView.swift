//
//  ContentView.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/12.
//
import Combine
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firebaseManager: FirebaseManager
    @AppStorage("userId") var userId: String?
    @State var test = false
    @State var increasedFloors = 0
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        VStack{
            switch firebaseManager.signUpState {
            case .beforeSignUp:
                LoginView()
            case .duringSignUp:
                CreateNameView()
            case .afterSignUp:
                StageView()
            }
            if test {
                Button("+\(increasedFloors)층"){
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
                            }
                        }
                    }
                    User.instance.isFloorsChanged = false
                }
            }
        }
        .onAppear{
            if userId != nil {
                firebaseManager.signUpState = .afterSignUp
            }
            else {
                firebaseManager.signUpState = .beforeSignUp
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .isFloorsChanged).receive(on: RunLoop.main).eraseToAnyPublisher()){ newValue in
            
            guard let isChanged = newValue.userInfo?.first?.value as? Bool else {return}
            self.test = isChanged
            self.increasedFloors = User.instance.increasedFloorsCount
            
            print("데이터 : \(User.instance.lastVisitDateUserFloor)")
            print("데이터 배열 : \(User.instance.userFloorsTemp)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
