//
//  StairTest.swift
//  OrrNyan Watch App
//
//  Created by Jay on 2023/07/12.
//

import SwiftUI
import CoreMotion

struct StairTest: View {
    let motionActivityManager = CMMotionActivityManager()
    let cmPedometer = CMPedometer()
    @State private var isWalking = false
    @State var stairCount = 0
    
    var body: some View {
        VStack {
            Text(isWalking ? "걷는 중" : "정지 중")
            Button {
                startMonitoringMotion()
            } label: {
                Text("걷기 모니터링 시작")
            }
            
            Text("계단 : \(stairCount)")
            Button {
                motionActivity()
            } label: {
                Text("계단 시작")
            }
                
        }
        .padding()
    }
    
    func motionActivity() {
        if CMPedometer.isFloorCountingAvailable() {
            print("층수 사용 가능")
            let cmPedometerData = CMPedometerData().floorsAscended
            
            cmPedometer.startUpdates(from: Date()) { data, error in
                stairCount = data?.floorsAscended as! Int
                print("계단 층계: \(data?.floorsAscended)")
            }
        }
        else {
            print("층수 사용 불가능")
        }
    }
    
    func startMonitoringMotion() {
        motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            DispatchQueue.main.async {
                if let isWalking = activity?.walking {
                    self.isWalking = isWalking
                }
            }
        }
    }
}

struct StairTest_Previews: PreviewProvider {
    static var previews: some View {
        StairTest()
    }
}
