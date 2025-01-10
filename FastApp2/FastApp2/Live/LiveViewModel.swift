//
//  LiveViewModel.swift
//  FastAPP2
//
//  Created by PKW on 1/10/25.
//

import Foundation

enum LiveSortOption {
    case favorite
    case start
}

@MainActor
class LiveViewModel {
    private(set) var items: [Live.Item]?
    private(set) var sortOption: LiveSortOption = .favorite
    var dataChanged: (([Live.Item]) -> Void)?

    func request(sort: LiveSortOption) {
        Task {
            do {
                let live = try await NetworkLoader.loadData(url: APIEndpoints.live, for: Live.self)
                let items: [Live.Item]
                
                if sort == .start {
                    items = live.list.reversed()
                } else {
                    items = live.list
                }

                self.items = items
                self.dataChanged?(items)
            } catch {
                print("live data load failed")
            }
        }
    }
}
