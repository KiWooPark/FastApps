//
//  DateComponentsFormatter+Ext.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import Foundation

extension DateComponentsFormatter {
    static let playTimeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]

        return formatter
    }()
}
