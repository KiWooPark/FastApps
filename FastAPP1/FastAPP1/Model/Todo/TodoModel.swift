//
//  TodoModel.swift
//  FastAPP1
//
//  Created by PKW on 11/27/24.
//

import Foundation

struct TodoModel: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var convertedDayAndTime: String {
        return String("\(day.fDay) - \(time.fTime)에 알림")
    }
}
