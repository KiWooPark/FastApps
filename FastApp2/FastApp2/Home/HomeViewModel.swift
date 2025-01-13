// Created by 박기우
// All rights reserved.

import Foundation

@MainActor
class HomeViewModel {
    
    // (set) 쓰기 접근 권한 제한하기
    private(set) var homeModel: Home?
    let recommendViewModel: HomeRecommendViewModel = .init()
    
    // 데이터 업데이트 클로저
    var dataChanged: (() -> Void)?
    
    func requestData() {
        Task {
            do {
//                let home = try await NetworkLoader.loadData(url: APIEndpoints.home, for: Home.self)
                let home = try await NetworkLoader.load(json: "home", for: Home.self)
                self.homeModel = home
                self.recommendViewModel.recommends = home.recommends
                self.dataChanged?()
            } catch {
                print("request Data Error")
            }
        }
    }
}
