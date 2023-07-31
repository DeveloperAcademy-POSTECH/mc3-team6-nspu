//
//  StairTest.swift
//  OrrNyan Watch App
//
//  Created by Jay on 2023/07/12.
//

import SwiftUI
import CoreMotion

struct StairTest: View {
    //    let motionActivityManager = CMMotionActivityManager()
    let cmPedometer = CMPedometer()
    
    @State var stairCount = 0
    
    var body: some View {
        VStack {
            Text("계단 : \(stairCount)")
                .onAppear {
                    startFloorsCount()
                }
        }
        .padding()
    }
    
    func startFloorsCount() {
        if CMPedometer.isFloorCountingAvailable() {
            print("층수 사용 가능")
            let cmPedometerData = CMPedometerData().floorsAscended
            
            cmPedometer.startUpdates(from: Date()) { data, error in
                stairCount = data?.floorsAscended as! Int
            }
        }
        else {
            print("층수 사용 불가능")
        }
    }
}

struct StairTest_Previews: PreviewProvider {
    static var previews: some View {
        StairTest()
    }
}
