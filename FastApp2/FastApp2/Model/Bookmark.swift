//
//  Bookmark.swift
//  FastAPP2
//
//  Created by PKW on 1/3/25.
//

import Foundation

struct Bookmark: Decodable {
    let channels: [Item]
}

extension Bookmark {
    struct Item: Decodable {
        let channel: String
        let channelId: Int
        let thumbnail: URL
    }
}
