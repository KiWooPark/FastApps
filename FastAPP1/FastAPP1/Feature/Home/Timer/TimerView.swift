//
//  TimerView.swift
//  FastAPP1
//
//  Created by PKW on 12/3/24.
//

import SwiftUI

struct TimerView: View {
    @StateObject var timerViewModel = TimerViewModel()
    
    var body: some View {
        if timerViewModel.isDisplaySetTimeView {
            // 타이머 설정 뷰
            SetTimerView(timerViewModel: timerViewModel)
        } else {
            // 타이머 작동 뷰
            TimerOperationView(timerViewModel: timerViewModel)
        }
    }
}


// MARK: - 타이머 설정 뷰
private struct SetTimerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel

    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            TitleView()
            
            Spacer()
                .frame(height: 50)
            
            TimerPickerView(timerViewModel: timerViewModel)
            
            Spacer()
                .frame(height: 30)
            
            TimerCreateBtnView(timerViewModel: timerViewModel)
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("타이머")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.customBlack)
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 20)
    }
}

private struct TimerPickerView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    var body: some View {
        VStack {
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
            
            HStack {
                Picker("1", selection: $timerViewModel.time.hours) {
                    ForEach(0..<24) { hour in
                        Text("\(hour)시")
                    }
                }
                
                Picker("1", selection: $timerViewModel.time.minutes) {
                    ForEach(0..<60) { minute in
                        Text("\(minute)분")
                    }
                }
                
                Picker("1", selection: $timerViewModel.time.seconds) {
                    ForEach(0..<60) { second in
                        Text("\(second)초")
                    }
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
            
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
        }
    }
}
// MARK: - 타이머 생성 버튼 뷰
private struct TimerCreateBtnView: View {
    
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        Button(
            action: {
                timerViewModel.settingBtnTapped()
            }, label: {
                Text("설정하기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.customGreen)
            }
        )
    }
}

// MARK: - 타이머 작동 뷰
private struct TimerOperationView: View {
    @ObservedObject private var timerViewModel: TimerViewModel
    
    fileprivate init(timerViewModel: TimerViewModel) {
        self.timerViewModel = timerViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            ZStack {
                VStack {
                    Text("\(timerViewModel.timeRemaining.fTimeStrng)")
                        .font(.system(size: 20))
                        .foregroundStyle(.customBlack)
                        .monospaced()
                    
                    HStack(alignment: .bottom) {
                        Image(systemName: "bell.fill")
                        Text("\(timerViewModel.timeRemaining.fSettingTime)")
                            .font(.system(size: 16))
                            .foregroundStyle(.customBlack)
                    }
                }
                
               Circle()
                    .stroke(Color.customOrange, lineWidth: 6)
                    .frame(width: 350)
            }
            
            Spacer()
                .frame(height: 10)
            
            HStack {
                Button(
                    action: {
                        timerViewModel.cancelBtnTapped()
                    }, label: {
                        Text("취소")
                            .font(.system(size: 16))
                            .foregroundStyle(.customBlack)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 22)
                            .background(
                                Circle()
                                    .fill(.customGray2.opacity(0.3))
                            )
                    }
                )
                
                Spacer()
                    
                Button(
                    action: {
                        timerViewModel.pauseOrRestartBtnTapped()
                    }, label: {
                        Text(timerViewModel.isPaused ? "계속 진행" : "일시 정지")
                            .font(.system(size: 14))
                            .foregroundStyle(.customBlack)
                            .padding(.vertical, 25)
                            .padding(.horizontal, 7)
                            .background(
                                Circle()
                                    .fill(.customOrange.opacity(0.3))
                            )
                    }
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TimerView()
}
