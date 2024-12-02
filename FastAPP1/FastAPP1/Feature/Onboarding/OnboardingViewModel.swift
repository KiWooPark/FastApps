//
//  OnboardingViewModel.swift
//  FastAPP1
//
//  Created by PKW on 11/26/24.
//

import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var onboardingContents: [OnboardingContentModel]
    
    init(onboardingContents: [OnboardingContentModel] = [
        .init(imageFileName: "onboarding_1", title: "오늘의 할일", subTitle: "To do list로 언제 어디서든 해야할일을 한눈에"),
        .init(imageFileName: "onboarding_2", title: "오늘의 할일", subTitle: "To do list로 언제 어디서든 해야할일을 한눈에"),
        .init(imageFileName: "onboarding_3", title: "오늘의 할일", subTitle: "To do list로 언제 어디서든 해야할일을 한눈에"),
        .init(imageFileName: "onboarding_4", title: "오늘의 할일", subTitle: "To do list로 언제 어디서든 해야할일을 한눈에")
    ])
    {
        self.onboardingContents = onboardingContents
    }
}
