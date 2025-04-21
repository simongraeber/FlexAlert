//
//  LoggerService.swift
//  FlexAllert
//
//  Created by Simon Graeber on 15.04.25.
//

import Foundation
import os.log

final class LoggerService {
    // Singleton instance
    static let shared = LoggerService()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.default.app", category: "main")

    private init() {}
}
