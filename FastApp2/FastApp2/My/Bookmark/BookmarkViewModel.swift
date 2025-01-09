//
//  BookmarkViewModel.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import Foundation

@MainActor class BookmarkViewModel {
    
    private(set) var channels: [Bookmark.Item]?
    var dataChanged: (() -> Void)?
    
    func request() {
        Task {
            do {
                let data = try await NetworkLoader.loadData(url: APIEndpoints.bookmark, for: Bookmark.self)
                self.channels = data.channels
                self.dataChanged?()
            } catch {
                print("bookmark list load failed: \(error.localizedDescription)")
            }
            
        }
    }
}

