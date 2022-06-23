//
//  DataFetchHelper.swift
//  BackgroundTaskSwiftUIDemo
//
//  Created by Shunzhe on 2022/06/22.
//

import Foundation
import UserNotifications

class DataFetchHelper: NSObject, URLSessionDownloadDelegate {
    
    static let shared = DataFetchHelper(backgroundTaskIdentifier: "com.test.test.fetchRemoteData")
    
    private var urlSession: URLSession?
    
    init(backgroundTaskIdentifier: String) {
        super.init()
        let config = URLSessionConfiguration.background(withIdentifier: backgroundTaskIdentifier)
        config.sessionSendsLaunchEvents = true
        self.urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    func startRequestingQiitaWebsite() {
        let request = URLRequest(url: URL(string: "https://qiita.com")!)
        let task = urlSession?.downloadTask(with: request)
        task?.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let textData = try? String(contentsOf: location, encoding: .utf8) {
            if textData.contains("Swift") {
                let content = UNMutableNotificationContent()
                content.title = "Today's Qiita web page contains Swift keyword."
                content.sound = .default
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: trigger)
                let notificationCenter = UNUserNotificationCenter.current()
                notificationCenter.add(request)
            }
        }
    }
    
}
