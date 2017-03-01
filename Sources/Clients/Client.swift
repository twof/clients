import URI
import HTTP
import JWT
import JSON

public protocol Client {
    static var name: String { get }
    var jwt: JWT? { get }
    var client: ClientProtocol { get }
    init(_ client: ClientProtocol, _ jwt: JWT?)
}

extension Client {
    public func respond(
        to method: HTTP.Method,
        path: String,
        _ json: JSON? = nil
    ) throws -> Response {
        let newUri = URI(
            scheme: client.scheme,
            host: client.host,
            port: client.port,
            path: path
        )

        let request = try Request(method: method, uri: newUri)
        if let json = json {
            request.body = .data(try json.serialize())
            request.headers["Content-Type"] = "application/json"
        }

        if let jwt = jwt {
            request.headers["Authorization"] = "Bearer \(try jwt.createToken())"
        }

        let res = try client.respond(to: request)
        guard res.status.statusCode < 400  else {
            print("❌ \(Self.name) request failed.")
            print(res)

            throw ClientsError.badResponse(res.status)
        }
        return res
    }
}
