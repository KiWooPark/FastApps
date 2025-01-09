//
//  FavoriteViewModel.swift
//  FastAPP2
//
//  Created by PKW on 1/9/25.
//

import Foundation

@MainActor class FavoriteViewModel {
    private(set) var favorite: Favorite?
    var dataChanged: (() -> Void)?
    
    func request() {
        Task {
            do {
                let favorite = try await NetworkLoader.loadData(url: APIEndpoints.favorite, for: Favorite.self)
                self.favorite = favorite
                self.dataChanged?()
            } catch {
                print("favorite load failed \(error.localizedDescription)")
            }
        }
    }
}
