//
//  OnboardingContent.swift
//  FastAPP1
//
//  Created by PKW on 11/26/24.
//

import Foundation

struct OnboardingContentModel: Hashable {
    var imageFileName: String
    var title: String
    var subTitle: String
    
    init(imageFileName: String, title: String, subTitle: String) {
        self.imageFileName = imageFileName
        self.title = title
        self.subTitle = subTitle
    }
}
