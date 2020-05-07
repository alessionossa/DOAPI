//
//  DOSSHKey.swift
//  DOAPI
//
//  Created by L. Dillinger on 7/27/18.
//

import Foundation

public struct DOSSHKey: Codable, Hashable {
    
    public var id: Int
    public var fingerprint: String
    public var publicKey: String
    public var name: String
    
    public enum Identifier {
        
        case id(Int)
        case fingerprint(String)
        
        var string: String {
            switch self {
            case let .id(id):
                return "\(id)"
            case let .fingerprint(fingerprint):
                return fingerprint
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case fingerprint
        case publicKey = "public_key"
        case name
    }
    
    public struct Create: DORequest, Encodable {
        
        public typealias Body = Create
        
        public var name: String
        public var publicKey: String
        
        enum CodingKeys: String, CodingKey {
            case name
            case publicKey = "public_key"
        }
        
        public struct Response: DOResponse {
            public let sshKey: DOSSHKey
            enum CodingKeys: String, CodingKey {
                case sshKey = "ssh_key"
            }
        }
        
        public let method = "POST"
        public var path: String { return "account/keys" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(name: String, publicKey: String) {
            self.name = name
            self.publicKey = publicKey
        }
        
    }
    
    public struct Get: DORequest {
        
        public var identifier: Identifier
        
        public struct Response: DOResponse {
            public let sshKey: DOSSHKey
            enum CodingKeys: String, CodingKey {
                case sshKey = "ssh_key"
            }
        }
        
        public let method = "GET"
        public var path: String { return "account/keys/\(identifier.string)" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init(identifier: Identifier) {
            self.identifier = identifier
        }
    }
    
    public struct List: DORequest {
        
        public struct Response: DOResponse {
            public let sshKeys: [DOSSHKey]
            enum CodingKeys: String, CodingKey {
                case sshKeys = "ssh_keys"
            }
        }
        
        public let method = "GET"
        public var path: String { return "account/keys" }
        public let query: [String : String]? = nil
        public let body: DONull? = nil
        
        public init() { }
    }
    
    public struct Update: DORequest, Encodable {
        
        public typealias Body = Update
        
        public var identifier: Identifier
        public var name: String
        
        enum CodingKeys: String, CodingKey {
            case name
        }
        
        public struct Response: DOResponse {
            public let sshKey: DOSSHKey
            enum CodingKeys: String, CodingKey {
                case sshKey = "ssh_key"
            }
        }
        
        public let method = "PUT"
        public var path: String { return "account/keys/\(identifier.string)" }
        public let query: [String : String]? = nil
        public var body: Body? { return self }
        
        public init(identifier: Identifier, name: String) {
            self.identifier = identifier
            self.name = name
        }
        
    }
    
    public struct Delete: DORequest {
        
        public var identifier: Identifier
        
        public struct Response: DOResponse { }
        
        public let method = "DELETE"
        public var path: String { return "account/keys/\(identifier.string)" }
        public let query: [String : String]? = nil
        public var body: DONull? = nil
        
        public init(identifier: Identifier) {
            self.identifier = identifier
        }
        
    }
    
}
