//
//  TimeModel.swift
//  FastAPP1
//
//  Created by PKW on 12/3/24.
//

import Foundation

struct TimeModel {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var convertedSeconds: Int {
        return (hours * 3600) + (minutes * 60) + seconds
    }
    
    static func fromSeconds(_ seconds: Int) -> TimeModel {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = (seconds % 3600) % 60
        return TimeModel(hours: hours, minutes: minutes, seconds: remainingSeconds)
    }
}
