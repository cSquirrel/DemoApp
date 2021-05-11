//
//  Helpers.swift
//  SpaceXTests
//
//  Created by Marcin Maciukiewicz on 08/05/2021.
//

import Foundation
@testable import SpaceX

fileprivate let formatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
}()

extension Date {
    
    func asString() -> String {
        return formatter.string(from: self)
    }
    
    static func from(string: String) -> Date {
        return formatter.date(from: string)!
    }
}

extension LaunchModel.Property: Equatable {
    static public func == (lhs: LaunchModel.Property, rhs: LaunchModel.Property) -> Bool {
        return
            lhs.label == rhs.label &&
            lhs.value == rhs.value
    }
}
