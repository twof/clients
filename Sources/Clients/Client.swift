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
        _ content: RequestSerializable? = nil
    ) throws -> Response {
        let request: Request
        do {
            let newUri = URI(
                scheme: client.scheme,
                host: client.host,
                port: client.port,
                path: path
            )

            request = try Request(
                method: method,
                uri: newUri
            )
            try content?.serialize(to: request)

            if let jwt = jwt {
                request.headers["Authorization"] = "Bearer \(try jwt.createToken())"
            }
        } catch {
            throw ClientsError.createRequest(error)
        }

        let res: Response
        do {
            res = try client.respond(to: request)
        } catch {
            throw ClientsError.connect(error)
        }

        guard res.status.statusCode < 400  else {
            print("❌ \(Self.name) request failed.")
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
