//
//  DOImage.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOImage: Codable {
    
    public enum ImageType: String, Codable {
        case snapshot
        case backup
        case base
    }
    
    public var id: Int
    public var name: String
    public var type: ImageType
    public var distribution: String
    public var slug: String?
    public var isPublic: Bool
    public var regions: [String]
    public var minDiskInGiB: Int
    // NOTE: Discrepancy - documented as integer, returned as fractional
    public var sizeInGiB: Double
    public var createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case distribution
        case slug
        case isPublic = "public"
        case regions
        case minDiskInGiB = "min_disk_size"
        case sizeInGiB = "size_gigabytes"
        case createdAt = "created_at"
    }
    
    public struct List: DOPagedRequest {
        
        public enum ImageType: String, CustomStringConvertible {
            
            case distribution
            case application
            case snapshot
            case custom
            case backup
            
            public var description: String {
                switch self {
                case .distribution:
                    return "Distribution"
                case .application:
                    return "Application"
                case .snapshot:
                    return "Snapshot"
                case .custom:
                    return "Custom"
                case .backup:
                    return "Backup"
                }
            }
        }
        
        public var type: ImageType?
        public var privateOnly: Bool?
        public var page: Int
        public var perPage: Int
        
        public struct Response: DOResponse {
            public let images: [DOImage]
        }
        
        public let method = "GET"
        public let path = "images"
        public var query: [String : String]? {
            var items: [String: String] = [
                "page": "\(page)",
                "per_page": "\(perPage)",
            ]
            if let type = type {
                items["type"] = "\(type.rawValue)"
                
            }
            if let privateOnly = privateOnly {
                items["private"] = "\(privateOnly)"
            }
            return items.isEmpty ? nil : items
        }
        public let body: DONull? = nil
        
        public init(type: ImageType? = nil, privateOnly: Bool = false, page: Int = 0, perPage: Int = 200) {
            self.type = type
            self.privateOnly = privateOnly
            self.page = page
            self.perPage = perPage
        }
    }
    
    public struct Get: DORequest {
        
        public var id: Int
        
        public struct Response: DOResponse {
            public let image: DOImage
        }
        
        public let method = "GET"
        public var path: String { return "images/\(id)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
    }
    
    public struct GetByName: DORequest {
        
        public var name: String
        
        public struct Response: DOResponse {
            public let image: DOImage
        }
        
        public let method = "GET"
        public var path: String { return "images/\(name)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(name: String) {
            self.name = name
        }
    }
    
    public struct Update: DORequest, Encodable {
        
        public typealias Body = Update
        
        public var id: Int
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
        
        public struct Response: DOResponse {
            public let image: DOImage
        }
        
        public let method = "PUT"
        public var path: String { return "images/\(id)" }
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
        public var path: String { return "images/\(id)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(id: Int) {
            self.id = id
        }
        
    }
    
}
