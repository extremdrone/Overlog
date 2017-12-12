//
//  ConsoleLogsMonitor.swift
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

/// A class to monitor the logs printed in the console
final public class ConsoleLogsMonitor: LogsMonitor {

    public var delegate: LogsMonitorDelegate?

    /// A buffer of logs
    public fileprivate(set) var logs: [LogEntry] = []

    /// Start monitoring for new data in standard and error outputs.
    ///
    /// - Remark:
    /// Subscribes for gathering logs which won't be visible in a console window anymore.
    /// It is a workaround for a fact that stdout and stderr outputs can be redirected only to a one handle.
    public func subscribeForLogs() {
        let pipe = Pipe()
        let handle = pipe.fileHandleForReading
        dup2(pipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
        dup2(pipe.fileHandleForWriting.fileDescriptor, fileno(stdout))

        NotificationCenter.default.addObserver(self, selector: #selector(dataAvailable(notification:)), name: .NSFileHandleDataAvailable, object: nil)
        handle.waitForDataInBackgroundAndNotify()
    }

    /// Parse available output data
    @objc private func dataAvailable(notification: Notification) {
        if let fileHandle = notification.object as? FileHandle {

            if let parsedData = NSString(data: fileHandle.availableData, encoding: String.Encoding.utf8.rawValue) {
                let newLog = LogEntry(date: Date(), sender: nil, message: parsedData as String)
                logs.insert(newLog, at: 0)
                DispatchQueue.main.async {
                    self.delegate?.monitor(self, didGet: self.logs)
                }
            }

            fileHandle.waitForDataInBackgroundAndNotify()
        }
    }
}
