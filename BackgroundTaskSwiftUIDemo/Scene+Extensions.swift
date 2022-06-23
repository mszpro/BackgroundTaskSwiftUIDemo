//
//  Scene+Extensions.swift
//  BackgroundTaskSwiftUIDemo
//
//  Created by Shunzhe on 2022/06/22.
//

import Foundation
import SwiftUI

extension Scene {
    func backgroundTaskIfAvailable(_ taskIdentifier: String, action: @Sendable @escaping () async -> Void) -> some Scene {
        if #available(iOS 16.0, *) {
            return self
                .backgroundTask(.appRefresh(taskIdentifier), action: action)
        } else {
            return self
        }
    }
}
