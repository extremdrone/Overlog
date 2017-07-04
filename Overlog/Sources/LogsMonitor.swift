//
//  LogsMonitor.swift
//  Overlog
//
//  Copyright © 2017 Netguru Sp. z o.o. All rights reserved.
//

import Foundation
/// ASL module is deprecated and replaced by os_log(3). However, the new implementation
/// lacks a possibility to search for logs in the current run environment (it has yet
/// to be implemented / released to the public by Apple). The decission was made to
/// use the ASL as is it still being supported.
import asl

/// A class to monitor the logs printed in the console
final public class LogsMonitor {

    /// A delegate for notifications
    weak public var delegate: LogsMonitorDelegate?

    /// The ASL client associated with the receiver
    public fileprivate(set) var aslClient: aslclient

    public init() {
        self.aslClient = asl_open(ProcessInfo.processInfo.processName, nil, 0x00000001)
        asl_add_log_file(self.aslClient, 2)
    }

    public func scanForLogs() {

        /// Searching for all logs
        let query = asl_new(UInt32(ASL_TYPE_QUERY))
        let results = asl_search(self.aslClient, query)

        var logsDictionary = [String: String]()
        var record = asl_next(results)

        /// Iterating for logs read by asl_search command
        while record != nil {

            var i = UInt32(0)
            var key = asl_key(record, i)
            while key != nil {
                let keyStr = String(cString: key!)
                if let val = asl_get(record, keyStr) {
                    let valString = String(cString: val)
                    logsDictionary[keyStr] = valString
                }
                i += 1
                key = asl_key(record, i)
            }

            delegate?.monitor(self, didGet: logsDictionary)
            record = asl_next(results)
        }

        asl_release(results)
    }

    deinit {
        asl_close(aslClient)
    }

}

/// A LogsMonitorDelegate delegate protocol for notification whenever any log appears in the console
public protocol LogsMonitorDelegate: class {

    /// Triggerd when LogsMonitor gets a new log
    ///
    /// - parameter monitor: An object that get notice about a log
    /// - parameter log: recived log
    func monitor(_ monitor: LogsMonitor, didGet logs: [String: String])

}
