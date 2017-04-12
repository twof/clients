import URI
import Vapor
import JWT
import JSON
import HTTP

public protocol Client {
    static var name: String { get }
    var baseUri: URI { get }
    var jwt: JWT? { get }
    var client: ClientProtocol { get }
    init(_ client: ClientProtocol, _ baseUri: URI, _ jwt: JWT?)
}

extension Client {
    public func respond(
        to method: HTTP.Method,
        path: String,
        _ content: RequestSerializable? = nil
    ) throws -> Response {
        let req: Request
        do {
            let newUri = baseUri.appendingPathComponent(path)
            req = Request(
                method: method,
                uri: newUri
            )
            try content?.serialize(to: req)

            if let jwt = jwt {
                req.headers["Authorization"] = "Bearer \(try jwt.createToken())"
            }
        } catch {
            throw ClientsError.createRequest(error)
        }

        let res: Response
        do {
            res = try client.respond(to: req)
        } catch {
            throw ClientsError.connect(error)
        }

        guard res.status.statusCode < 400  else {
            print("❌ \(Self.name) request failed.")
            print(req)
            print(res)

            throw ClientsError.badResponse(res.status)
        }

        return res
    }

}

public protocol RequestSerializable {
    func serialize(to request: Request) throws
}

extension JSON: RequestSerializable {
    public func serialize(to request: Request) throws {
        request.body = .data(try serialize())
        request.headers["Content-Type"] = "application/json"
    }
}
