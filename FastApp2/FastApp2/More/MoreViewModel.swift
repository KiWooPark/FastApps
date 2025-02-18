//
//  MoreViewModel.swift
//  FastAPP2
//
//  Created by PKW on 1/7/25.
//

import Foundation

struct MoreViewModel {
    let items: [MoreItem] = [
        .init(title: "화질 변경", rightText: "자동 720"),
        .init(title: "자동 재생", rightText: "On"),
        .init(title: "공유하기", rightText: nil),
        .init(title: "신고하기", rightText: nil)
    ]
}

struct MoreItem {
    let title: String
    let rightText: String?
}
