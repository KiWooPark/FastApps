//
//  Double+Extensions.swift
//  FastAPP1
//
//  Created by PKW on 12/2/24.
//

import Foundation

extension Double {
    var fTimeInterval: String {
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
