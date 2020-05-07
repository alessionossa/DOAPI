//
//  DOVolume.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

// NOTE: Block Storage Volume - "Block Storage" omitted for brevity
public struct DOVolume: Codable {
    
    public enum FilesystemType: String, Codable {
        case ext4
        case xfs
    }
    
    public var id: Int
    public var region: DORegion
    public var dropletIds: [Int]
    public var name: String
    // NOTE: desc -> description, but clashes with String description
    public var desc: String?
    // GiB =  1024^3
    public var sizeInGiB: Int
    public var createdAt: Date
    public var filesystemType: FilesystemType
    public var filesystemLabel: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case region
        case dropletIds = "droplet_ids"
        case name
        case desc = "description"
        case sizeInGiB = "size_gigabytes"
        case createdAt = "created_at"
        case filesystemType = "filesystem_type"
        case filesystemLabel = "filesystem_label"
    }
    
    public struct List: DORequest {
        
        public var region: String?
        
        public struct Response: DOResponse {
            public let volumes: [DOVolume]
        }
        
        public let method = "GET"
        public let path = "volumes"
        public var query: [String : String]? {
            if let region = region {
                return ["region": region]
            } else {
                return nil
            }
        }
        public let body: DONull? = nil
        
        public init(region: String?) {
            self.region = region
        }
    }
    
    public struct Create: DORequest, Encodable {
        
        public typealias Body = Create
        
        public var name: String
        // NOTE: desc -> description, but clashes with String description
        public var desc: String?
        
        // GiB =  1024^3
        public var sizeInGiB: Int
        
        // NOTE: Only one should be present
        public var region: String?
        public var snapshot: Int?
        
        // NOTE: Label should only be present if type is
        public var filesystemType: FilesystemType?
        public var filesystemLabel: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case desc = "description"
            case sizeInGiB = "size_gigabytes"
            case region
            case snapshot = "snapshot_id"
            case filesystemType = "filesystem_type"
            case filesystemLabel = "filesystem_label"
        }
        
        public struct Response: DOResponse {
            public let volume: DOVolume
        }
        
        public let method = "POST"
        public let path = "volumes"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(name: String, desc: String?, sizeInGiB: Int, region: String?, snapshot: Int?, filesystemType: FilesystemType?, filesystemLabel: String?) {
            self.name = name
            self.desc = desc
            self.sizeInGiB = sizeInGiB
            self.region = region
            self.snapshot = snapshot
            self.filesystemType = filesystemType
            self.filesystemLabel = filesystemLabel
        }
        
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let action: DOAction
        }
        
        public let method = "GET"
        public var path: String { return "volumes/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct GetByName: DORequest {
        
        public var name: String
        public var region: String
        
        public struct Response: DOResponse {
            public let volumes: [DOVolume]
        }
        
        public let method = "GET"
        public let path = "volumes"
        public var query: [String : String]? {
            return [
                "name": name,
                "region": region,
            ]
        }
        public let body: DONull? = nil
        
        public init(name: String, region: String) {
            self.name = name
            self.region = region
        }
    }
    
    public struct ListSnapshots: DOPagedRequest {
        
        public var id: Int
        public var page: Int?
        public var perPage: Int?
        
        public struct Response: DOPagedResponse {
            public var links: DOLinks
            
            public var meta: DOMeta
            
            public let snapshots: [DOSnapshot]
        }
        
        public let method = "GET"
        public var path: String { return "volumes/\(id)/snapshots" }
        public var query: [String : String]? {
            var items: [String: String] = [:]
            if (page != nil && perPage != nil) {
                items = [
                    "page": "\(page!)",
                    "per_page": "\(perPage!)",
                ]
            }
            
            items["id"] = "\(id)"
            return items
        }
        public let body: DONull? = nil
        
        public init(id: Int, page: Int = 0, perPage: Int = 200) {
            self.id = id
            self.page = page
            self.perPage = perPage
        }
    }
    
    
    public struct CreateSnapshot: DORequest, Encodable {
        
        public typealias Body = CreateSnapshot
        
        public var id: Int
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
        }
        
        public struct Response: DOResponse {
            public let snapshot: DOSnapshot
        }
        
        public let method = "POST"
        public var path: String { return "volumes/\(id)/snapshots" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
        
    }
    
    public struct Delete: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "volumes/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct DeleteByName: DORequest {
        
        public var name: String
        public var region: String
        
        public struct Response: DOResponse {
            public let volumes: [DOVolume]
        }
        
        public let method = "DELETE"
        public let path = "volumes"
        public var query: [String : String]? {
            return [
                "name": name,
                "region": region,
            ]
        }
        public let body: DONull? = nil
        
        public init(name: String, region: String) {
            self.name = name
            self.region = region
        }
    }
    
    public typealias DeleteSnapshot = DOSnapshot.Delete
    
}

