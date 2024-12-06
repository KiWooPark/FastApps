//
//  OnboardingView.swift
//  FastAPP1
//
//  Created by PKW on 11/26/24.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
    
    @StateObject private var todoListViewModel = TodoListViewModel()
    @StateObject private var memoListViewModel = MemoListViewModel()
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            OnboardingContentView(onboardingViewModel: onboardingViewModel)
                .navigationDestination(
                    for: PathType.self,
                    destination: { pathType in
                        switch pathType {
                        case .homeView:
                            HomeView()
                                .navigationBarBackButtonHidden()
                                .environmentObject(todoListViewModel)
                                .environmentObject(memoListViewModel)
                        case .todoView:
                            TodoView()
                                .navigationBarBackButtonHidden()
                                .environmentObject(todoListViewModel)
                        case let .memoView(isCreateMode, memo):
                            MemoView(
                                memoViewModel: isCreateMode
                                ? .init(memo: .init(title: "", content: "", date: .now))
                                : .init(memo: memo ?? .init(title: "", content: "", date: .now)),
                                isCreateMode: isCreateMode
                            )
                            .navigationBarBackButtonHidden()
                            .environmentObject(memoListViewModel)
                        }
                    }
                )
        }
        .environmentObject(pathModel)
    }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀 리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            
            // 시작 버튼 뷰
            StartButtonView()
        }
        .edgesIgnoringSafeArea(.top)
        
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    fileprivate init(onboardingViewModel: OnboardingViewModel, selectedIndex: Int = 0) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, content in
                OnboardingCellView(onboardingContent: content)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width ,height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0 ? Color.customSky : Color.customBackgroundGreen
        )
        .clipped()
    }
}

private struct OnboardingCellView: View {
    // 사용할 데이터 모델
    private var onboardingContent: OnboardingContentModel
    
    fileprivate init(onboardingContent: OnboardingContentModel) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 8)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                    
                }
                
                Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(10)
        }
        .shadow(radius: 10)
    }
}

// MAKR: - 시작하기 뷰
private struct StartButtonView: View {
    
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.homeView)
        } label: {
            HStack {
                Text("시작하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.customGreen)
                
                Image("startHome")
                    .renderingMode(.template)
                    .foregroundStyle(.customGreen)
            }
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    OnboardingView()
}
