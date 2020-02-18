//
//  Log.swift
//  Peripheral_Example
//
//  Created by Balázs Kilvády on 6/24/16.
//  Copyright © 2016 kil-dev. All rights reserved.
//

import Foundation

private func _DLogMessage(file: String, items: [Any]) -> (String, String) {
    var s = ""
    items.forEach {
        s += String(describing: $0)
    }
    let file = file.lastPathComponent
    return (file, s)
}

#if DEBUG
    func DLog(_ s: String, file: String = #file, line: Int = #line) {
        print("<\(file.lastPathComponent):\(line)> \(s)")
    }

    func DLog(file: String = #file, line: Int = #line, _ items: Any...) {
        print("<\(file.lastPathComponent):\(line)> ", terminator: "")
        items.forEach {
            print($0, terminator: "")
        }
        print()
    }

#else
    func DLog(_ s: String, file: String = #file, line: Int = #line) {}

    func DLog(file: String = #file, line: Int = #line, _ items: Any...) {}
#endif

private func _rfind<C: Collection>(domain: C, value: C.Element) -> C.Index? where C.Element: Equatable {
    for idx in domain.indices.reversed() {
        if domain[idx] == value {
            return idx
        }
    }
    return nil
}

extension String {
    var lastPathComponent: String {
        return componentsSeparated(by: "/")
    }

    func componentsSeparated(by separator: String.Element) -> String {
        if let idx = _rfind(domain: self, value: separator) {
            return String(self[self.index(after: idx)...])
        }
        return self
    }
}