//
//  DODropletAction.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/28/18.
//

import Foundation

public struct DODropletAction: Codable {
    
    public enum Status: String, Codable {
        case inProgress = "in-progress"
        case completed
        case errored
    }
    
    public enum ActionType: String, Codable {
        case enableBackups = "enable_backups"
        case disableBackups = "disable_backups"
        case reboot
        case powerCycle = "power_cycle"
        case shutdown
        case powerOff = "power_off"
        case powerOn = "power_on"
        case restore
        case passwordReset = "password_reset"
        case resize
        case rebuild
        case rename
        case changeKernel = "change_kernel"
        case enableIPv6 = "enable_ipv6"
        case enablePrivateNetworking = "enable_private_networking"
        case snapshot
    }
    
    public var id: Int
    public var status: Status
    public var type: ActionType
    public var startedAt: Date
    public var completedAt: Date?
    public var resourceId: Int?
    public var resourceType: String
    public var region: DORegion
    public var regionSlug: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case type
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case resourceId = "resource_id"
        case resourceType = "resource_type"
        case region
        case regionSlug = "region_slug"
    }
    
    public struct EnableBackups: DORequest, Encodable {
        
        public typealias Body = EnableBackups
        
        public var id: Int
        
        let type: ActionType = .enableBackups
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct DisableBackups: DORequest, Encodable {
        
        public typealias Body = DisableBackups
        
        public var id: Int
        
        let type: ActionType = .disableBackups
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct Reboot: DORequest, Encodable {
        
        public typealias Body = Reboot
        
        public var id: Int
        
        let type: ActionType = .reboot
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct PowerCycle: DORequest, Encodable {
        
        public typealias Body = PowerCycle
        
        public var id: Int
        
        let type: ActionType = .powerCycle
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct Shutdown: DORequest, Encodable {
        
        public typealias Body = Shutdown
        
        public var id: Int
        
        let type: ActionType = .shutdown
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct PowerOn: DORequest, Encodable {
        
        public typealias Body = PowerOn
        
        public var id: Int
        
        let type: ActionType = .powerOn
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct PowerOff: DORequest, Encodable {
        
        public typealias Body = PowerOff
        
        public var id: Int
        
        let type: ActionType = .powerOff
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct Restore: DORequest, Encodable {
        
        public typealias Body = Restore
        
        public var id: Int
        
        let type: ActionType = .restore
        public var image: DODroplet.ImageIdentifier
        
        enum CodingKeys: String, CodingKey {
            case type
            case image
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, image: DODroplet.ImageIdentifier) {
            self.id = id
            self.image = image
        }
        
    }
    
    public struct PasswordReset: DORequest, Encodable {
        
        public typealias Body = PasswordReset
        
        public var id: Int
        
        let type: ActionType = .passwordReset
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct Resize: DORequest, Encodable {
        
        public typealias Body = Resize
        
        public var id: Int
        
        let type: ActionType = .resize
        public var disk: Bool
        public var size: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case disk
            case size
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, disk: Bool, size: String) {
            self.id = id
            self.disk = disk
            self.size = size
        }
        
    }
    
    public struct Rebuild: DORequest, Encodable {
        
        public typealias Body = Rebuild
        
        public var id: Int
        
        let type: ActionType = .rebuild
        public var image: DODroplet.ImageIdentifier
        
        enum CodingKeys: String, CodingKey {
            case type
            case image
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, image: DODroplet.ImageIdentifier) {
            self.id = id
            self.image = image
        }
        
    }
    
    public struct Rename: DORequest, Encodable {
        
        public typealias Body = Rename
        
        public var id: Int
        
        let type: ActionType = .rename
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case name
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
        
    }
    
    struct ChangeKernel: DORequest, Encodable {
        
        public typealias Body = ChangeKernel
        
        public var id: Int
        
        let type: ActionType = .changeKernel
        public var kernel: Int
        
        enum CodingKeys: String, CodingKey {
            case type
            case kernel
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, kernel: Int) {
            self.id = id
            self.kernel = kernel
        }
        
    }
    
    public struct EnableIPv6: DORequest, Encodable {
        
        public typealias Body = EnableIPv6
        
        public var id: Int
        
        let type: ActionType = .enableIPv6
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct EnablePrivateNetworking: DORequest, Encodable {
        
        public typealias Body = EnablePrivateNetworking
        
        public var id: Int
        
        let type: ActionType = .enablePrivateNetworking
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct Snapshot: DORequest, Encodable {
        
        public typealias Body = Snapshot
        
        public var id: Int
        
        let type: ActionType = .snapshot
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case type
            case name
        }
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "POST"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
        
    }
    
    // TODO: Tagged droplet actions
    
    public struct Get: DORequest {
        
        public var id: Int
        public var actionId: Int
        
        public struct Response: DOResponse {
            public let action: DODropletAction
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)/actions/\(actionId)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int, actionId: Int) {
            self.id = id
            self.actionId = id
        }
    }
    
    // NOTE: No list droplet actions?
}
