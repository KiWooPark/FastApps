//
//  Date+Extensions.swift
//  FastAPP1
//
//  Created by PKW on 11/27/24.
//

import Foundation

extension Date {
    var fTime: String {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateFormat = "a hh:mm"
        return f.string(from: self)
    }
    
    var fDay: String {
        let now = Date()
        let calendar = Calendar.current
        
        let nowStartOfDay = calendar.startOfDay(for: now)
        let dateStartOfDay = calendar.startOfDay(for: self)
        let numOfDaysDifference = calendar.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!
        
        if numOfDaysDifference == 0 {
            return "오늘"
        } else {
            let f = DateFormatter()
            f.locale = Locale(identifier: "ko_kr")
            f.dateFormat = "M월 d일 E요일"
            return f.string(from: self )
        }
    }
}
