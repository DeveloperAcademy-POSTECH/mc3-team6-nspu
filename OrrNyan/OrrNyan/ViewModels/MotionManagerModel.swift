//
//  MotionManager.swift
//  backUp
//
//  Created by qwd on 2023/07/29.
//

import SwiftUI
import CoreMotion

class MotionManagerModel: ObservableObject {
    //MARK: - 모션 매니져 프로퍼티
    @Published var manager: CMMotionManager = .init()
    @Published var xValue: CGFloat = 0
    @Published var yValue: CGFloat = 0
    
    func detectMotion(){
        //MARK: - 모션 활성화 됐을 때
        if !manager.isDeviceMotionActive{
            manager.deviceMotionUpdateInterval = 1/40
            manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, err in
                if let attitude = motion?.attitude{
                    self?.xValue = attitude.roll
                    self?.yValue = attitude.yaw
                }
            }
        }
    }
    //MARK: - 불필요한 모션 제거
    func stopMotionUpdates(){
        manager.stopDeviceMotionUpdates()
    }
}



