//
//  DataLoader.swift
//  FastAPP2
//
//  Created by PKW on 1/4/25.
//

import Foundation

enum NetworkLoader {
    private static let session: URLSession = .shared
    
    enum NetworkLoaderError: Error {
        case invalidURL
        case noData
        case decodingFailed
        case requestFailed(Error)
    }

    // 제네릭을 사용해서 범용적으로 사용
    static func loadData<T: Decodable>(url: String, for type: T.Type) async throws -> T {
        guard let url = URL(string: url) else {
            throw URLError(.unsupportedURL)
        }
        
        let data = try await Self.session.data(for: URLRequest(url: url)).0
        let jsonDecoder = JSONDecoder()
        
        return try jsonDecoder.decode(T.self, from: data)
    }

    // 이미지 로드
    static func loadImageData(from url: URL) async throws -> Data {
        let (data, response) = try await session.data(for: .init(url: url))
        
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkLoaderError.requestFailed(URLError(.badServerResponse))
        }
        
        guard !data.isEmpty else {
            throw NetworkLoaderError.noData
        }
        
        return data
    }
    
    static func load<T: Decodable>(json: String, for type: T.Type) throws -> T {
        guard let jsonUrl = Bundle.main.url(forResource: json, withExtension: "json")
        else {
            throw JSONError.notFound
        }
        
        let jsonDecoder = JSONDecoder()
        let data = try Data(contentsOf: jsonUrl)
        let model = try jsonDecoder.decode(T.self, from: data)
        return model
    }
}

enum JSONError: Error {
    case notFound
}
