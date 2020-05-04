//
//  DODroplet.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DODroplet: Codable {
    
    public enum Status: String, Codable {
        case new
        case active
        case off
        case archive
    }
    
    public struct Networks: Codable {
        
        enum NetworkCodingKeys: String, CodingKey {
            case ipAddress = "ip_address"
            case netmask
            case gateway
            case type
        }
        
        public struct IPv4Network: Codable {
            public var ipAddress: String
            public var netmask: String
            public var gateway: String
            public var type: String
            typealias CodingKeys = NetworkCodingKeys
        }
        
        public struct IPv6Network: Codable {
            public var ipAddress: String
            public var netmask: Int
            public var gateway: String
            public var type: String
            typealias CodingKeys = NetworkCodingKeys
        }
        
        public var v4: [IPv4Network]
        public var v6: [IPv6Network]
        // Others?
    }
    
    public struct Kernel: Codable {
        public var id: Int
        public var name: String
        public var version: String
    }
    
    public struct BackupWindow: Codable {
        // TODO: Figure out structure
    }
    
    public enum ImageIdentifier: Encodable {
        
        case id(Int)
        case slug(String)
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case let .id(id):
                try container.encode(id)
            case let .slug(slug):
                try container.encode(slug)
            }
        }
    }
    
    // TODO: Headless
    
    public var id: Int
    public var name: String
    
    public var memoryInMiB: Int
    public var virtualCPUs: Int
    public var diskInGiB: Int
    
    public var locked: Bool
    
    public var createdAt: Date
    public var status: Status
    
    public var backupIds: [Int]
    public var snapshotIds: [Int]
    
    public var features: [String]
    
    public var region: DORegion
    
    public var image: DOImage
    
    public var size: DOSize
    public var sizeSlug: String
    
    public var networks: Networks
    public var kernel: Kernel?
    public var nextBackupWindow: BackupWindow?
    
    public var tags: [String]
    
    public var volumeIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case memoryInMiB = "memory"
        case virtualCPUs = "vcpus"
        case diskInGiB = "disk"
        case locked
        case createdAt = "created_at"
        case status
        case backupIds = "backup_ids"
        case snapshotIds = "snapshot_ids"
        case features
        case region
        case image
        case size
        case sizeSlug = "size_slug"
        case networks
        case kernel
        case nextBackupWindow = "next_backup_window"
        case tags
        case volumeIds = "volume_ids"
    }
    
    public struct Create: DORequest, Encodable {
        
        public typealias Body = Create
        
        // TODO: Headless
        
        public var name: String
        public var region: String
        public var size: String
        public var image: DODroplet.ImageIdentifier
        public var sshKeys: [String]?
        public var backups: Bool
        public var ipv6: Bool
        public var privateNetworking: Bool
        public var userData: String?
        public var monitoring: Bool
        public var volumes: [Int]?
        public var tags: [String]?
        
        enum CodingKeys: String, CodingKey {
            case name
            case region
            case size
            case image
            case sshKeys = "ssh_keys"
            case backups
            case ipv6
            case privateNetworking = "private_networking"
            case userData = "user_data"
            case monitoring
            case volumes
            case tags
        }
        
        public struct Response: DOResponse {
            public let droplet: DODroplet
        }
        
        public let method = "POST"
        public let path = "droplets"
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(name: String, region: String, size: String, image: DODroplet.ImageIdentifier, sshKeys: [String]?, backups: Bool = false, ipv6: Bool, privateNetworking: Bool = false, userData: String? = nil, monitoring: Bool = false, volumes: [Int]? = nil, tags: [String]? = nil) {
            self.name = name
            self.region = region
            self.size = size
            self.image = image
            self.sshKeys = sshKeys
            self.backups = backups
            self.ipv6 = ipv6
            self.privateNetworking = privateNetworking
            self.userData = userData
            self.monitoring = monitoring
            self.volumes = volumes
            self.tags = tags
        }
        
    }
    
    //struct CreateMultiple: DORequest {
    //    public typealias Body = CreateMultiple
    //    struct Response: DOResponse {
    //        let volume: DODroplet
    //    }
    //    public let method = "POST"
    //    public let path = "droplets"
    //    public let query: [String : String]? = nil
    //    public var body: Body? { return self }
    //}
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let droplet: DODroplet
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct List: DOPagedRequest {
        
        public var tag: String?
        public var page: Int
        public var perPage: Int
        
        public struct Response: DOResponse {
            public let droplets: [DODroplet]
        }
        
        public let method = "GET"
        public let path = "droplets"
        public var query: [String : String]? {
            var items = [
                "page": "\(page)",
                "per_page": "\(perPage)",
            ]
            if let tag = tag {
                items["tag"] = tag
            }
            return items
        }
        public let body: DONull? = nil
        
        public init(tag: String? = nil, page: Int = 0, perPage: Int = 200) {
            self.tag = tag
            self.page = page
            self.perPage = perPage
        }
    }
    
    public struct ListKernels: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let kernels: [DODroplet.Kernel]
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)/kernels" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct ListSnapshots: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let snapshots: [DOImage]
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)/snapshots" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct ListBackups: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let snapshots: [DOImage]
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)/backups" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct ListActions: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let actions: [DODropletAction]
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)/actions" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct Delete: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "droplets/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
    public struct DeleteByTag: DORequest {
        
        public var tag: String
        
        public struct Response: DOResponse {
            public let volumes: [DOVolume]
        }
        
        public let method = "DELETE"
        public let path = "droplets"
        public var query: [String : String]? {
            return [
                "tag": tag,
            ]
        }
        public let body: DONull? = nil
        
        public init(tag: String) {
            self.tag = tag
        }
    }
    
    public struct ListNeighbors: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let droplets: [DODroplet]
        }
        
        public let method = "GET"
        public var path: String { return "droplets/\(id)/neighbors" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    // TODO: All droplet neighbors
    
}
