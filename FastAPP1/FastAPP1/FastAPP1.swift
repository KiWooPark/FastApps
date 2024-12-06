//
//  FastAPP1App.swift
//  FastAPP1
//
//  Created by PKW on 11/25/24.
//

import SwiftUI

@main
struct FastAPP1: App {
    
    // 한번만 선언해야 함
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
