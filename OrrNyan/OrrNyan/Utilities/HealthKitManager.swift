//
//  HealthKitManager.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/27.
//

import Foundation
import HealthKit

struct FloorData {
    var date: Date
    var floors: Int
}

class HealthKitManager {
    
    private let healthStore = HKHealthStore()
    
    /// date날짜 부터 어제까지의 데이터를 받아옵니다
    func fetchFloorsData(_ lastVisitDate: Date, completion: @escaping ([FloorData]?, Error?) -> Void) {
        // HealthKit을 사용할 수 있는지 확인
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.OrrNyang", code: 1, userInfo: [NSLocalizedDescriptionKey: "건강 앱 데이터를 사용할 수 없습니다."]))
            return
        }
            
        // 건강 데이터 유형 생성
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        
        // 데이터 읽기 권한 요청
    
        self.healthStore.requestAuthorization(toShare: nil, read: [stepCountType]) { (success, error) in
            if success {
                // 오늘 기준 3일 전과 오늘까지의 날짜 범위 계산
                let calendar = Calendar.current
                let now = Date()
//                let threeDaysAgo = calendar.date(byAdding: .day, value: -3, to: now)!
                let startDate = calendar.startOfDay(for: lastVisitDate)
                let endDate = calendar.startOfDay(for: now)
//                guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {return}
                
                // 건강 데이터 쿼리 생성
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
                let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                        quantitySamplePredicate: predicate,
                                                        options: .cumulativeSum,
                                                        anchorDate: startDate,
                                                        intervalComponents: DateComponents(day: 1))
                
                query.initialResultsHandler = { query, results, error in
                    guard let results = results else {
                        completion(nil, error)
                        return
                    }
                    
                    var stepCountsByDate: [FloorData] = []
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                        if let sum = statistics.sumQuantity() {
                            let date = statistics.startDate
                            let stepCount = sum.doubleValue(for: HKUnit.count())
                            let floorDate = FloorData(date: date, floors: Int(stepCount))
                            stepCountsByDate.append(floorDate)
                        }
                    }
                    
                    completion(stepCountsByDate, nil)
                }
                // 쿼리 실행
                self.healthStore.execute(query)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
    /// 오늘의 층수 데이터를 받아옵니다.
    func fetchTodayFloorsData(completion: @escaping (FloorData?, Error?) -> Void) {
        // HealthKit을 사용할 수 있는지 확인
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil, NSError(domain: "com.OrrNyang", code: 1, userInfo: [NSLocalizedDescriptionKey: "건강 앱 데이터를 사용할 수 없습니다."]))
            return
        }
        
        // 건강 데이터 유형 생성
        let stepCountType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed)!
        
        // 데이터 읽기 권한 요청
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: nil, read: [stepCountType]) { (success, error) in
            if success {
                // 오늘 기준 3일 전과 오늘까지의 날짜 범위 계산
                let calendar = Calendar.current
                let now = Date()
                let startDate = calendar.startOfDay(for: now)
                guard let endDate = calendar.date(byAdding: .day, value: 1, to: startDate) else {return}
                
                // 건강 데이터 쿼리 생성
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
                let query = HKStatisticsCollectionQuery(quantityType: stepCountType,
                                                        quantitySamplePredicate: predicate,
                                                        options: .cumulativeSum,
                                                        anchorDate: startDate,
                                                        intervalComponents: DateComponents(day: 1))
                
                query.initialResultsHandler = { query, results, error in
                    guard let results = results else {
                        completion(nil, error)
                        return
                    }
                    
                    results.enumerateStatistics(from: startDate, to: endDate) { statistics, stop in
                        if let sum = statistics.sumQuantity() {
                            let date = statistics.startDate
                            let stepCount = sum.doubleValue(for: HKUnit.count())
                            let floorData = FloorData(date: date, floors: Int(stepCount))
                            completion(floorData, nil)

                        }
                    }
                    
                    
                }
                
                // 쿼리 실행
                healthStore.execute(query)
            } else {
                completion(nil, error)
            }
        }
    }

}
