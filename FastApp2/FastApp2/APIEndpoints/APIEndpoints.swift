//
//  APIEndpoint.swift
//  FastAPP2
//
//  Created by PKW on 1/3/25.
//

import Foundation

enum APIEndpoints {
    private static let base = "http://localhost:8080"
    static let home = "\(base)/home"
    static let live = "\(base)/live"
    static let bookmark = "\(base)/my/bookmark"
    static let favorite = "\(base)/my/favorite"
    static let video = "\(base)/video"
}
