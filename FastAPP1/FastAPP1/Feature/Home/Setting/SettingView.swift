//
//  SettingView.swift
//  FastAPP1
//
//  Created by PKW on 12/6/24.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject private var HomeViewModel: HomeViewModel
    
    var body: some View {
        
        VStack {
            // 타이틀 뷰
            TitleView()
            
            Spacer()
                .frame(height: 35)
            
            // 총 탭 카운트 뷰
            TotalTabCountView()
            
            Spacer()
                .frame(height: 35)
            
            // 총 탭 무브 뷰
            TotalTabMoveView()
            
            Spacer()
        }
    }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
   
    var body: some View {
        HStack {
            Text("설정")
                .font(.system(size: 30, weight: .bold))
            
            Spacer()
        }
        .padding(.horizontal, 30)
        .padding(.top, 45)
    }
}

// MARK: - 총 토탈 카운트 뷰
private struct TotalTabCountView: View {
    @EnvironmentObject private var HomeViewModel: HomeViewModel

    fileprivate var body: some View {
        HStack {
            TabCountView(title: "To do", count: HomeViewModel.todoCount)
            Spacer()
                .frame(width: 70)
            TabCountView(title: "메모", count: HomeViewModel.memoCount)
            Spacer()
                .frame(width: 70)
            TabCountView(title: "음성 메모", count: HomeViewModel.voiceRecorderCount)
        }
    }
}

// MARK: - 각 탭에 설정된 카운트 뷰(재사용 뷰)
private struct TabCountView: View {
    private var title: String
    private var count: Int
    
    fileprivate init(
        title: String,
        count: Int
    ) {
        self.title = title
        self.count = count
    }
    
    fileprivate var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.system(size: 14))
                .foregroundStyle(.customBlack)
            
            Text("\(count)")
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.customBlack)
        }
    }
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTabMoveView: View {
    @EnvironmentObject private var HomeViewModel: HomeViewModel
    
    fileprivate var body: some View {
        VStack {
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
            
            TabMoveView(
                title: "To do 리스트",
                tabAction: { 
                    HomeViewModel.changeSelectedTab(.todoList)
                }
            )
            
            TabMoveView(
                title: "메모",
                tabAction: {
                    HomeViewModel.changeSelectedTab(.memo)
                }
            )
            
            TabMoveView(
                title: "음성 메모",
                tabAction: {
                    HomeViewModel.changeSelectedTab(.voiceRecorder)
                }
            )
            
            TabMoveView(
                title: "타이머", tabAction: {
                    HomeViewModel.changeSelectedTab(.timer)
                }
            )

            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
        }
    }
}

// MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {
    private var title: String
    private var tabAction: () -> Void
    
    fileprivate init(
        title: String,
        tabAction: @escaping () -> Void
    ) {
        self.title = title
        self.tabAction = tabAction
    }
    
    fileprivate var body: some View {
        Button(
            action: tabAction ,
            label: {
                Text(title)
                    .font(.system(size: 14))
                    .foregroundStyle(.customBlack)
                
                Spacer()
                
                Image("arrowRight")
            }
        )
        .padding(.all, 20)
    }
}

#Preview {
    SettingView()
        .environmentObject(HomeViewModel())
}
