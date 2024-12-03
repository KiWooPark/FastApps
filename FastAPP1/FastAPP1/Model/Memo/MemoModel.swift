//
//  MemoModel.swift
//  FastAPP1
//
//  Created by PKW on 12/2/24.
//

import Foundation

struct MemoModel: Hashable {
    var title: String
    var content: String
    var date: Date
    var id = UUID()
    
    var convertedDate: String {
        String("\(date.fDay) - \(date.fTime)")
    }
}
