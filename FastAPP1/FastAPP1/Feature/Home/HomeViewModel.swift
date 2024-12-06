//
//  HomeViewModel.swift
//  FastAPP1
//
//  Created by PKW on 11/27/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var todoCount: Int
    @Published var memoCount: Int
    @Published var voiceRecorderCount: Int
    
    init(
        selectedTab: Tab = .voiceRecorder,
        todoCount: Int = 0,
        memoCount: Int = 0,
        voiceRecorderCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todoCount = todoCount
        self.memoCount = memoCount
        self.voiceRecorderCount = voiceRecorderCount
    }
}

extension HomeViewModel {
    func setTodoCount(_ count: Int) {
        todoCount = count
    }
    
    func setMemoCount(_ count: Int) {
        memoCount = count
    }
    
    func setVoiceRecorderCount(_ count: Int) {
        voiceRecorderCount = count
    }
    
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
