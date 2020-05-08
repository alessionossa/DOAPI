//
//  DONull.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DONull: Equatable, Hashable, Comparable, Codable {
    
    public static func ==(lhs: DONull, rhs: DONull) -> Bool {
        return true
    }
    
    public static func <(lhs: DONull, rhs: DONull) -> Bool {
        return false
    }
    
//    public var hashValue: Int { return 0 }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    public static let null = DONull()
}

extension DONull: DOResponse {
}
