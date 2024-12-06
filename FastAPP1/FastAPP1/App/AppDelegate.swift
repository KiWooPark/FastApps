//
//  AppDelegate.swift
//  FastAPP1
//
//  Created by PKW on 12/3/24.
//

import UIKit

// 노티피케이션 사용하기 위해 (로우 레빌 작업)
class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
