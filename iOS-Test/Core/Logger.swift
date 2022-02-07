import CocoaLumberjack
import Foundation

internal enum LoggerLevel {
    case verbose
    case debug
    case info
    case warn
    case error
}

internal enum LoggerType {
    case common
    case warning
    case error
    case assert
    case fatalError

    internal func prefix() -> String {
        switch self {
        case .common: return ""
        case .warning: return "Warning: "
        case .error: return "Error: "
        case .assert: return "Assert: "
        case .fatalError: return "Fatal Error: "
        }
    }

}

internal class Logger {

    static func setup() {
        /*
         If you set the log level to DDLogLevelError , then you will only see Error statements.
         If you set the log level to DDLogLevelWarn, then you will only see Error and Warn statements.
         If you set the log level to DDLogLevelInfo, you'll see Error, Warn and Info statements.
         If you set the log level to DDLogLevelDebug, you'll see Error, Warn, Info and Debug statements.
         If you set the log level to DDLogLevelVerbose, you'll see all DDLog statements.
         If you set the log level to DDLogLevelOff, you won't see any DDLog statements.
         */
        DDLog.removeAllLoggers()

#if DEBUG
        // DDOSLogger much faster then DDTTYLogger. DDTTYLogger can cause xcode freeze when big data logged.
        DDLog.add(DDOSLogger.sharedInstance, with: DDLogLevel.debug) // does not log to iphone console
        // DDLog.add(DDTTYLogger.sharedInstance!, with: DDLogLevel.debug) // xcode console - on ios 10 and higher causes duplicates in xcode console
        // DDLog.add(DDASLLogger.sharedInstance, with: DDLogLevel.debug) // console.app
#else
        DDLog.add(DDASLLogger.sharedInstance, with: DDLogLevel.warning) // console.app
#endif

        // DDLogLevelInfo DDLogLevelWarn DDLogLevelError are written to log file
        let fileLogger = DDFileLogger()

        fileLogger.rollingFrequency = 60 * 60 * 1 // 1 hour rolling
        fileLogger.maximumFileSize = 20 * 1024 * 1024 // 20 Mb rolling
        fileLogger.doNotReuseLogFiles = true // creating new log file on every app start
        fileLogger.logFileManager.maximumNumberOfLogFiles = 4

        DDLog.add(fileLogger, with: DDLogLevel.info)
    }

    static func ddttyLogger() -> DDTTYLogger? {
        return DDLog.allLoggers.first(where: { $0 is DDTTYLogger }) as? DDTTYLogger
    }

    static func ddaslLogger() -> DDOSLogger? {
        return DDLog.allLoggers.first(where: { $0 is DDOSLogger }) as? DDOSLogger
    }

    static func ddFileLogger() -> DDFileLogger? {
        return DDLog.allLoggers.first(where: { $0 is DDFileLogger }) as? DDFileLogger
    }

    static func writeInfoLog(_ log: String, file: StaticString = #file, line: UInt = #line, addNewLines: Bool = true) {
        writeLog(log, file: file, line: line, level: LoggerLevel.info, addNewLines: addNewLines, loggerType: LoggerType.common)
    }

    static func writeErrorLog(_ log: String, file: StaticString = #file, line: UInt = #line, addNewLines: Bool = true) {
        writeLog(log, file: file, line: line, level: LoggerLevel.error, addNewLines: addNewLines, loggerType: LoggerType.error)
    }

    static func assertionFailure(_ log: String, file: StaticString = #file, line: UInt = #line, addNewLines: Bool = true) {
        writeLog(log, file: file, line: line, level: LoggerLevel.error, addNewLines: addNewLines, loggerType: LoggerType.assert)
        Swift.assertionFailure(log)
    }

    static func fatalError(_ log: String, file: StaticString = #file, line: UInt = #line, addNewLines: Bool = true) -> Never {
        writeLog(log, file: file, line: line, level: LoggerLevel.error, addNewLines: addNewLines, loggerType: LoggerType.fatalError)
        Swift.fatalError(log)
    }

    static func writeLog(_ log: String,
                         file: StaticString = #file,
                         line: UInt = #line,
                         level: LoggerLevel = .debug,
                         addNewLines: Bool = true,
                         loggerType: LoggerType = .common) {
        let logConclusive: String
        let prefix = loggerType.prefix()
        let filename = URL(string: "\(file)")?.lastPathComponent ?? ""
        if addNewLines {
            logConclusive = "\(filename):\(line)\n\(prefix)\(log)\n\n"
        } else {
            logConclusive = "\(filename):\(line):\(prefix)\(log)"
        }
        switch level {
        case .verbose:
            DDLogVerbose(logConclusive)
        case .debug:
            DDLogDebug(logConclusive)
        case .info:
            DDLogInfo(logConclusive)
        case .warn:
            DDLogWarn(logConclusive)
        case .error:
            DDLogError(logConclusive)
        }
    }

    /**
     - returns: array of file descriptors for log file sorted by creation date. First is oldest file.
     */
    internal static func logFileInfos() -> [DDLogFileInfo] {
        guard let fileLogger = Logger.ddFileLogger() else {
            return []
        }

        let calendar = Calendar.current
        let currentDate = Date()
        let filteredFiles = fileLogger.logFileManager.sortedLogFileInfos.filter({ (fileInfo) -> Bool in
            return (calendar.dateComponents([.hour], from: fileInfo.creationDate ?? Date(), to: currentDate).hour ?? 0) <= 3
        })
        return filteredFiles.reversed()
    }

}
