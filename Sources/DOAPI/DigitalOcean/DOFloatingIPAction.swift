//
//  DOFloatingIPAction.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/28/18.
//

import Foundation

public struct DOFloatingIPAction: Codable {
    
    public enum Status: String, Codable {
        case inProgress = "in-progress"
        case completed
        case errored
    }
    
    public enum ActionType: String, Codable {
        case assign
        case unassign
    }
    
    public var id: Int
    public var status: Status
    public var type: ActionType
    public var startedAt: Date
    public var completedAt: Date
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
    
    public struct Assign: DORequest, Encodable {
        
        public typealias Body = Assign
        
        public var id: Int
        
        let type: ActionType = .assign
        public let dropletId: Int
        
        enum CodingKeys: String, CodingKey {
            case type
            case dropletId = "droplet_id"
        }
        
        public struct Response: DOResponse {
            public let action: DOFloatingIPAction
        }
        
        public let method = "POST"
        public var path: String { return "floating_ips/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, dropletId: Int) {
            self.id = id
            self.dropletId = dropletId
        }
        
    }
    
    public struct Unassign: DORequest, Encodable {
        
        public typealias Body = Unassign
        
        public var id: Int
        
        let type: ActionType = .unassign
        
        enum CodingKeys: String, CodingKey {
            case type
        }
        
        public struct Response: DOResponse {
            public let action: DOFloatingIPAction
        }
        
        public let method = "POST"
        public var path: String { return "floating_ips/\(id)/actions" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct List: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let actions: [DOFloatingIPAction]
        }
        
        public let method = "GET"
        public var path: String { return "floating_ips/\(id)/actions" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        public var actionId: Int
        
        public struct Response: DOResponse {
            public let action: DOFloatingIPAction
        }
        
        public let method = "GET"
        public var path: String { return "floating_ips/\(id)/actions/\(actionId)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int, actionId: Int) {
            self.id = id
            self.actionId = actionId
        }
    }

}
