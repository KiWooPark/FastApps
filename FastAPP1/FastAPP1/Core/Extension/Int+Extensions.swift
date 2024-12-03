//
//  Int+Extensions.swift
//  FastAPP1
//
//  Created by PKW on 12/3/24.
//

import Foundation

extension Int {
    var fTimeStrng: String {
        let time = TimeModel.fromSeconds(self)
        let hoursString = String(format: "%02d", time.hours)
        let minutesString = String(format: "%02d", time.minutes)
        let secondsString = String(format: "%02d", time.seconds)
        
        return "\(hoursString) : \(minutesString) : \(secondsString)"
    }
    
    var fSettingTime: String {
        let currentDate = Date()
        let settingDate = currentDate.addingTimeInterval(TimeInterval(self))
        
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.timeZone = TimeZone(identifier: "Asia/Seoul")
        f.dateFormat = "HH:mm"
        
        let fTime = f.string(from: settingDate)
        return fTime
    }
}
