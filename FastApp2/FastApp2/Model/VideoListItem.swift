//
//  VideoListItem.swift
//  FastAPP2
//
//  Created by PKW on 1/3/25.
//

import Foundation

struct VideoListItem: Decodable {
    let imageUrl: URL
    let title: String
    let playtime: Double
    let channel: String
    let videoId: Int
}
