//
//  BackgroundTaskSwiftUIDemoApp.swift
//  BackgroundTaskSwiftUIDemo
//
//  Created by Shunzhe on 2022/06/22.
//

import SwiftUI
import BackgroundTasks

@main
struct BackgroundTaskSwiftUIDemoApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .backgroundTask(.appRefresh("com.test.test.appRefreshTest")) {
            scheduleTestNotification()
            DataFetchHelper.shared.startRequestingQiitaWebsite()
        }
        .backgroundTask(.urlSession("com.test.test.fetchRemoteData")) { _ in
            _ = DataFetchHelper.shared
        }
    }
    
}

func scheduleTestNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Background task has run"
    content.sound = .default
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString,
                                        content: content,
                                        trigger: trigger)
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request)
}
