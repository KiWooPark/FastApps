//
//  Live.swift
//  FastAPP2
//
//  Created by PKW on 1/10/25.
//

import Foundation

struct Live: Decodable {
    let list: [Item]
}

extension Live {
    struct Item: Decodable {
        let videoId: Int 
        let thumbnailUrl: URL
        let title: String
        let channel: String
    }
}

