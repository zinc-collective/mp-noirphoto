//
//  LogManager.swift
//  NoirPhoto
//
//  Created by Cricket on 9/2/24.
//  Copyright © 2024 Moment Park. All rights reserved.
//

import os
import Sentry


protocol AppLogger {
    //https://theswiftdev.com/logging-for-beginners-in-swift
    func logError(_ error: Error)
    func logToConsole(_ message: String, _ level: OSLogType, _ category: LogManagerCategory)
}

enum LogManagerCategory: String {
    case splashVC       = "SplashViewController"
    case shareService   = "ShareService"
}


class LogManager: AppLogger {
    func logError(_ error: Error) {
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "error")
        logger.log(level: .error, "###--> \(error.localizedDescription)")
        SentrySDK.capture(error: error)
    }
    
    func logToConsole(_ message: String, _ level: OSLogType = .debug, _ category: LogManagerCategory = .splashVC) {
        #if DEBUG
        let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: category.rawValue)
        logger.log(level: level, "###--> \(message)")
        #endif
    }
}
