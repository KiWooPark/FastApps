//
//  TimerViewModel.swift
//  FastAPP1
//
//  Created by PKW on 12/3/24.
//

import Foundation

class TimerViewModel: ObservableObject {
    @Published var isDisplaySetTimeView: Bool
    @Published var time: TimeModel
    @Published var timer: Timer?
    @Published var timeRemaining: Int
    @Published var isPaused: Bool
    
    init(
        isDisplaySetTimeView: Bool = true,
        time: TimeModel = .init(hours: 0, minutes: 0, seconds: 0),
        timer: Timer? = nil,
        timeRemaining: Int = 0,
        isPaused: Bool = false
    ) {
        self.isDisplaySetTimeView = isDisplaySetTimeView
        self.time = time
        self.timer = timer
        self.timeRemaining = timeRemaining
        self.isPaused = isPaused
    }
}

extension TimerViewModel {
    func settingBtnTapped() {
        isDisplaySetTimeView = false
        
        timeRemaining = time.convertedSeconds
        
        // 타이머 시작 메서드 호출
        startTimer()
    }
    
    func cancelBtnTapped() {
        stopTimer()
        isDisplaySetTimeView = true
    }
    
    func pauseOrRestartBtnTapped() {
        if isPaused {
            // 타이머 시작 메서드
            startTimer()
        } else {
            timer?.invalidate()
            timer = nil
        }
        isPaused.toggle()
    }
}

// TimerViewModel 내부에서만 호출할 메서드들은 여기로!
private extension TimerViewModel {
    func startTimer() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    // 타이머 종료 메서드
                    self.stopTimer()
                }
            })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
