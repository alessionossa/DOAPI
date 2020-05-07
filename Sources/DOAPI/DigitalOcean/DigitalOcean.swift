import Foundation
import Combine

// Implementation of:
//  https://developers.digitalocean.com/documentation/v2/

// NOTE: All dates are ISO8601

public class DigitalOcean: ObservableObject {
    
    public static var shared: DigitalOcean {
        get {
            if (DigitalOcean._shared == nil) {
                DigitalOcean._shared = DigitalOcean.init(apiToken: "")
            }
            
            return DigitalOcean._shared!
        }
    }
    
    private static var _shared: DigitalOcean?
    
    typealias This = DigitalOcean
    
    static let api = "https://api.digitalocean.com/v2/"
    
    static let acceptableStatusRange: Range<Int> = 200..<300
    static let errorStatusRange: Range<Int> = 400..<500
    
    static let timeout: Double = 60.0
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    var apiToken: String
    var session: URLSession
    
    public init(apiToken: String, session: URLSession = URLSession(configuration: .ephemeral)) {
        
        self.apiToken = apiToken
        self.session = session
        
//        if This.shared == nil {
//            This.shared = self
//        }
    }
    
//    public static func initialize(apiToken: String, session: URLSession = URLSession(configuration: .ephemeral)) {
//        let _ = DigitalOcean(apiToken: apiToken, session: session)
//    }
    
    public func updateApiToken(newToken: String) {
        self.apiToken = newToken
        self.session = URLSession(configuration: .ephemeral)
        
        objectWillChange.send()
    }
    
    public func isTokenNotEmpty() -> Bool {
        return !self.apiToken.isEmpty
    }
    
    public func requestAll<Request: DOPagedRequest>(request req: Request, completion: @escaping (Bool, [Request.Response?]?, DOError?) -> Void) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(This.dateFormatter)
        encoder.outputFormatting = .prettyPrinted
        let bodyData: Data?
        if let body = req.body {
            guard let encodedBody = try? encoder.encode(body) else {
                let error = DOError.failedToEncodeBody(Request.Body.self, nil)
                DispatchQueue.global().async {
                    completion(false,nil,error)
                }
                return
            }
            
            bodyData = encodedBody
        } else {
            bodyData = nil
        }
        
        var totalResult: [Request.Response?] = []
        
        request(method: req.method, path: req.path, query: req.query, body: bodyData) { (success : Bool, result: Request.Response?, error: DOError?) in
            if success {
                totalResult.append(result)
                
                if let nextLink = result?.links.pages?.next {
                    print("Next link: \(nextLink)")
                    
                    guard let newComponents = URLComponents(string: nextLink) else {
                        fatalError("Cannot get components url: \(nextLink)")
                    }
                    
                    let newPage = newComponents.queryItems!
                        .first(where: { $0.name == "page" })!.value!
                    
                    let newPerPage = newComponents.queryItems!
                        .first(where: { $0.name == "perPage" })!.value!
                    
                    let newReq = req.changingPages(newPage: Int(newPage), newPerPage: Int(newPerPage))
                    
                    self.requestAll(request: newReq, completion: completion)
                } else {
                    completion(success, totalResult, error)
                }
                
            } else {
                completion(success, totalResult, error)
            }
        }
    }
    
    public func request<Request: DORequest>(request req: Request, completion: @escaping (Bool, Request.Response?, DOError?) -> Void) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(This.dateFormatter)
        encoder.outputFormatting = .prettyPrinted
        let bodyData: Data?
        if let body = req.body {
            guard let encodedBody = try? encoder.encode(body) else {
                let error = DOError.failedToEncodeBody(Request.Body.self, nil)
                DispatchQueue.global().async {
                    completion(false,nil,error)
                }
                return
            }
            
            bodyData = encodedBody
        } else {
            bodyData = nil
        }
        
        request(method: req.method, path: req.path, query: req.query, body: bodyData, completion: completion)
    }
    
    public func request<Result: Decodable>(method: String, path: String, query: [String:String]? = nil, body: Data? = nil, completion: @escaping (Bool, Result?, DOError?) -> Void) {
        let endpoint = "\(This.api)\(path)"
        var components = URLComponents(string: endpoint)
        
        if let query = query {
            components?.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        let succeed = { (result: Result) in
            DispatchQueue.global().async {
                completion(true,result,nil)
            }
        }
        
        let fail = { (error: DOError) in
            DispatchQueue.global().async {
                completion(false,nil,error)
            }
        }
        
        guard let url = components?.url else {
            fail(DOError.invalidEndpoint(endpoint))
            return
        }
        
        var request = URLRequest(
            url: url,
            cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: This.timeout
        )
        
        request.httpMethod = method
        
        if let body = body {
            request.httpBody = body
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            #if DEBUG
            let string = String(data: body, encoding: .utf8)!
            print("Encoded body:")
            print(string)
            #endif
        }
        
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { (data, resp, error) in
            
            guard error == nil else {
                fail(DOError.generic(error!.localizedDescription))
                return
            }
            
            guard let resp = resp as? HTTPURLResponse else {
                fail(DOError.badURLResponse)
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(This.dateFormatter)
            
            guard !This.errorStatusRange.contains(resp.statusCode) else {
                let error: DOError
                if let data = data, var remoteError = try? decoder.decode(DORemoteError.self, from: data) {
                    remoteError.status = resp.statusCode
                    error = DOError.remote(remoteError)
                } else {
                    error = DOError.errorStatusCode(resp.statusCode)
                }
                fail(error)
                return
            }
            
            guard This.acceptableStatusRange.contains(resp.statusCode) else {
                fail(DOError.unacceptableStatusCode(resp.statusCode))
                return
            }
            
            if resp.statusCode == 204 {
                print("Check result types")
                debugPrint(Result.self)
                debugPrint(Result.self is DONull.Type)
                
                succeed(DONull.null as! Result)
            }
            
            switch Result.self {
            case is DONull.Type:
                succeed(DONull.null as! Result)
                return
            default:
                guard let data = data else {
                    fail(DOError.missingBody)
                    return
                }
                
                do {
                    let result = try decoder.decode(Result.self, from: data)
                    succeed(result)
                    return
                } catch {
                    fail(DOError.failedToDecodeBody(Result.self, error))
                    return
                }
            }

        }
        task.resume()
    }
    
}

// Requests and response

public protocol DORequest {
    associatedtype Body: Encodable
    associatedtype Response: DOResponse
    var method: String { get }
    var path: String { get }
    var query: [String:String]? { get }
    var body: Body? { get }
}

public protocol DOResponse: Codable {
}

public protocol DOPagedRequest: DORequest where Response: DOPagedResponse {
    var page: Int? { get set }
    var perPage: Int? { get set }
}

extension DOPagedRequest {
    func changingPages(newPage: Int?, newPerPage: Int?) -> Self {
        var updatedRequest = self
        updatedRequest.page = newPage
        updatedRequest.perPage = newPerPage
        return updatedRequest
    }
}

public struct DOLinks: Codable {
    
    public struct Pages: Codable {
        var first: String?
        var prev: String?
        var next: String?
        var last: String?
    }
    
    public var pages: Pages?
}

public struct DOMeta: Codable {
    var total: Int
}

public protocol DOPagedResponse: DOResponse {
    
    var links: DOLinks { get }
    
    var meta: DOMeta { get }
}

// Errors

public enum DOError: Error {
    
    case remote(DORemoteError)
    case invalidEndpoint(String)
    
    case badFormatPortRange(String)
    case badURLResponse
    
    case errorStatusCode(Int)
    case unacceptableStatusCode(Int)
    case failedToEncodeBody(Any.Type,Error?)
    case failedToDecodeBody(Any.Type,Error?)
    
    case missingBody
    
    case generic(String)
}

extension DOError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case let .remote(remoteError):
            return remoteError.localizedDescription
        case let .invalidEndpoint(endpoint):
            return "Invalid endpoint: \(endpoint)"
        case let .generic(message):
            return "Generic error: \(message)"
        default:
            return "Undescribed error"
        }
    }
}



public struct DORemoteError: Error, Codable {
    
    public let id: String
    public let message: String
    public var status: Int?
    
}

extension DORemoteError: LocalizedError {
    public var errorDescription: String? {
        return [
            "Remote Error:",
            "\(id):",
            self.status.map { "code: \($0)" },
            "\(message)"
            ].compactMap { $0 }.joined(separator: " ")
    }
}
