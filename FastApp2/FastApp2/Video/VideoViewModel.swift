//
//  VideoViewModel.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import Foundation

@MainActor class VideoViewModel {
    
    private(set) var video: Video?
    var dataChangeHandler: ((Video) -> Void)?
    
    func request() {
        Task {
            do {
                let video = try await NetworkLoader.loadData(url: APIEndpoints.video, for: Video.self)
                self.video = video
                self.dataChangeHandler?(video)
            } catch {
                print("video load did failed \(error.localizedDescription)")
            }
            
        }
    }
}
