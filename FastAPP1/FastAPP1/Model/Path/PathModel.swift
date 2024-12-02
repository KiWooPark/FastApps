//
//  Path.swift
//  FastAPP1
//
//  Created by PKW on 11/27/24.
//

import Foundation

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
