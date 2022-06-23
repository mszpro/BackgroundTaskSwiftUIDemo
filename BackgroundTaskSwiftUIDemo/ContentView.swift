//
//  ContentView.swift
//  BackgroundTaskSwiftUIDemo
//
//  Created by Shunzhe on 2022/06/22.
//

import SwiftUI
import BackgroundTasks

struct ContentView: View {
    
    @State private var allUpdateRequests: [BGTaskRequest] = []
    @State private var schedulingErrorMessage: String?
    
    var body: some View {
        
        Form {
            
            Section {
                Button("Schedule a background task for 10 seconds later") {
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
                        return
                    }
                    scheduleAppRefresh()
                    loadBackgroundTaskRequestsList()
                }
                Button("Test notification") {
                    scheduleTestNotification()
                }
                Button("Test network request") {
                    DataFetchHelper.shared.startRequestingQiitaWebsite()
                }
                if let schedulingErrorMessage {
                    Label(schedulingErrorMessage, systemImage: "exclamationmark.triangle")
                }
            }
            
            // List all background update requests
            List(allUpdateRequests, id: \.identifier) { request in
                VStack {
                    Text(request.identifier)
                    if let earliestBeginDate = request.earliestBeginDate {
                        Text(DateFormatter.localizedString(from: earliestBeginDate, dateStyle: .long, timeStyle: .long))
                    }
                }
            }
            
        }
        .refreshable {
            loadBackgroundTaskRequestsList()
        }
        .onAppear {
            loadBackgroundTaskRequestsList()
        }
        
    }
    
    func loadBackgroundTaskRequestsList() {
        // Fetch all the background update requests
        BGTaskScheduler.shared.getPendingTaskRequests { requests in
            DispatchQueue.main.async {
                self.allUpdateRequests = requests
            }
        }
    }
    
    func scheduleAppRefresh() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
        if #available(iOS 16.0, *) {
            if let scheduledTime = Calendar.current.date(byAdding: .second, value: 10, to: Date()) {
                let request = BGAppRefreshTaskRequest(identifier: "com.test.test.appRefreshTest")
                request.earliestBeginDate = scheduledTime
                do {
                    try BGTaskScheduler.shared.submit(request)
                } catch {
                    DispatchQueue.main.async {
                        self.schedulingErrorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
