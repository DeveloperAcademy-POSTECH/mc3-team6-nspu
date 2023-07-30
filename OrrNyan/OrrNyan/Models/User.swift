
//
//  User.swift
//  OrrNyan
//
//  Created by Jay on 2023/07/27.
//

import Foundation

/// User 관련한 객체들을 하나로 통합해서 관리할 싱글톤 입니다.
class User {
    
    static var instance = User()
    
    private let healthKitManager = HealthKitManager()
    
    private init(){}
    var isToday = false
    var userInfo: UserInfo?
    var userFloor: UserFloor?
    var lastVisitDateUserFloor: UserFloor?
    var userFloorsTemp = [UserFloor]()
    
    var isFloorsChanged = false {
        didSet {
            NotificationCenter.default.post(name: .isFloorsChanged, object: self, userInfo: ["IsFloorsChanged": isFloorsChanged])
        }
    }
    
    var increasedFloorsCount = 0 {
        didSet {
            print("didset :\(increasedFloorsCount)")
            isFloorsChanged = true
        }
    }
    
    /// 날짜의 차이를 계산합니다.
    func calculateDate(_ lastVistDate: Date) -> Int? {
        let calendar = Calendar.current
        let now = Date()
        let dateComponents = calendar.dateComponents([.day], from: lastVistDate, to: now)
        if let difference = dateComponents.day {
            print("날짜 차이 값 \(difference)")
            return difference
        }
        else {
            print("difference is nil")
            return -1
        }
    }
    
    func updateFloorsData() {
        // 디폴트에서 UserFloor 가져오기
        guard let userFloor = self.fetchFloorsFromUserDefaults() else {return}
        
        // 날짜 비교
        let lastVisitDate = userFloor.date
        let dateResult = calculateDate(lastVisitDate)
        if dateResult == -1 {
            print("error")
            return
        }
        // 마지막 접족일이 같은날 이면
        else if dateResult == 0 {
            isToday = true
            healthKitManager.fetchTodayFloorsData { [weak self] result, error in
                guard let self = self else {return}
                guard let result else {
                    print("item 없다~ 아마도 오늘 데이터가 없는 경우")
                    return
                }
                let todayHealthKitdata = result
                print(todayHealthKitdata)
                
                let gap = todayHealthKitdata.floors - userFloor.dailyFloors
                self.lastVisitDateUserFloor = UserFloor(dailyFloors: todayHealthKitdata.floors, totalFloors: userFloor.totalFloors + gap, date: userFloor.date)
                if gap != 0 {
                    self.increasedFloorsCount = gap
                }
                // 음수인 경우는 아주 이상한 경우
                if self.increasedFloorsCount < 0 {
                    print("정말 이해가 안되는 경우로군요, 유저디폴트 값이 헬스 킷 데이터보다 많다니!? 서버에 로그 남기는 코드 짜라")
                }
            }
            
        }
        // 마지막 접속일이 다른날 이면
        else {
            isToday = false
            healthKitManager.fetchFloorsData(lastVisitDate) { [weak self] results, error in
                guard let self = self else {return}
                guard let results else {return}
                                
                // 마지막 접속일의 헬스킷 데이터
                guard let lastVisitHealthData = results.first?.floors else {return}
                let gap = lastVisitHealthData - userFloor.dailyFloors
                let total = userFloor.totalFloors + gap
                self.lastVisitDateUserFloor = UserFloor(dailyFloors: lastVisitHealthData, totalFloors: total, date: userFloor.date)
                
                // 2일 이상 안들어온 경우
                var totalFloorsTemp = userFloor.totalFloors + gap
                if results.count >= 2 {
                    // 접속하지 않은 날들의 데이터 입력
                    // totalFloorsTemp 는 접속 안한 날들의 토탈 갭이 된다
                    for i in (1...results.count - 1) {
                        totalFloorsTemp += results[i].floors
                        self.userFloorsTemp.append(UserFloor(dailyFloors: results[i].floors, totalFloors: totalFloorsTemp, date: results[i].date))
                    }
                }
                let didntLogIngap = totalFloorsTemp - userFloor.totalFloors
                // 오늘의 데이터
                var todayFloor = 0
                healthKitManager.fetchTodayFloorsData { [weak self] result, error in
                    guard let result else {return}
                    guard let self = self else {return}
                    todayFloor = result.floors
                    self.userFloorsTemp.append(UserFloor(dailyFloors: todayFloor, totalFloors: totalFloorsTemp + todayFloor, date: result.date))
                    
                    // 총 증가량
                    self.increasedFloorsCount = didntLogIngap + todayFloor
                }
            }
        }
    }
    
    func getUserFloorTemp() -> UserFloor? {
        if let lastVisitDateUserFloor {
            return lastVisitDateUserFloor
        }
        else {
            return nil
        }
    }
    
    func getUserFloorTempArray() -> [UserFloor]? {
        if userFloorsTemp.isEmpty {
            return nil
        }
        else {
            if let lastData = userFloorsTemp.last {}
            return userFloorsTemp
        }
    }
    /// 유저디폴트에서 UserFloor 데이터를 디코딩해서 가져옵니다
    func fetchFloorsFromUserDefaults() -> UserFloor? {
        guard let savedData = UserDefaults.standard.object(forKey: "userFloor") as? Data else {return nil}
        let decoder = JSONDecoder()
        guard let userFloor = try? decoder.decode(UserFloor.self, from: savedData) else {return nil}
        
        return userFloor
    }
    
    /// UserFloor 데이터를 인코딩해서 유저디폴트에 저장합니다.
    func saveFloorsToUserDefaults(_ userFloor: UserFloor) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userFloor){
            UserDefaults.standard.set(encoded, forKey: "userFloor")
        }
    }
}




extension Notification.Name {
    static let isFloorsChanged = Notification.Name("IsFloorsChanged")
}
