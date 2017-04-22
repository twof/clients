import HTTP
import JWT
import Vapor
import URI

// MARK: Client
public final class CloudAPI {
    public let accessTokenFactory: AccessTokenFactory?
    public let baseURI: URI
    public let client: ClientProtocol
    
    public init(
        _ client: ClientProtocol,
        _ baseURI: URI,
        _ accessTokenFactory: AccessTokenFactory?
    ) {
        self.client = client
        self.baseURI = baseURI
        self.accessTokenFactory = accessTokenFactory
    }
}

extension CloudAPI: Responder {
    public func respond(to req: Request) throws -> Response {
        let res: Response
        do {
            res = try client.respond(to: req)
        } catch {
            throw CloudAPIError.connect(error)
        }
        
        guard res.status.statusCode < 400  else {
            print("❌ Cloud API request failed.")
            print(req)
            print(res)

            let reason = res.json?["reason"]?.string
                ?? res.status.reason

            let error = ResponseError(
                status: res.status,
                reason: reason
            )
            
            throw error
        }
        
        return res
    }
    
    
    public func makeRequest(_ method: Method, path: NodeRepresentable...) throws -> Request {
        let path = try path.map({ node in
            return try node.makeNode(in: nil).string ?? ""
        }) .joined(separator: "/")
        return try makeRequest(method, path: path)
    }
    
    public func makeRequest(_ method: Method, path: String) throws -> Request {
        let uri = baseURI.appendingPathComponent(path)
        let req = Request(method: method, uri: uri)
        do {
            if let factory = accessTokenFactory {
                let token = try factory.makeAccessToken()
                req.headers["Authorization"] = "Bearer \(try token.makeString())"
            }
        } catch {
            throw CloudAPIError.createRequest(error)
        }
        return req
    }
}

// MARK: Convenience
