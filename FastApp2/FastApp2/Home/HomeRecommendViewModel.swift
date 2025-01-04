//
//  HomeRecommendViewModel.swift
//  FastAPP2
//
//  Created by PKW on 1/3/25.
//

import Foundation

class HomeRecommendViewModel {
    
    private(set) var isFolded: Bool = true {
        didSet {
            self.foldChanged?(self.isFolded)
        }
    }
    
    var foldChanged: ((Bool) -> Void)?
    var recommends: [VideoListItem]? = [
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 1),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 2),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 3),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 4),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 5),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 6),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 7),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 8),
    VideoListItem(imageUrl: nil, title: "1", playtime: 90, channel: "추천 채널", videoId: 9)
    ]
    
    var itemCount: Int {
        let count = self.isFolded ? 5 : self.recommends?.count ?? 0
        
        return min(self.recommends?.count ?? 0, count)
    }
    
    func toggleFoldState() {
        self.isFolded.toggle()
    }
}
