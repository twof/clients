import URI
import Vapor
import JWT
import JSON
import HTTP

//public protocol ClientProtocol {
//    static var name: String { get }
//    var baseUri: URI { get }
//    var jwt: JWT? { get }
//    var client: Vapor.ClientProtocol { get }
//    init(_ client: ClientProtocol, _ baseUri: URI, _ jwt: JWT?)
//}
//
//extension ClientProtocol {
//
//}

public protocol RequestSerializable {
    func serialize(to request: Request) throws
}

extension JSON: RequestSerializable {
    public func serialize(to request: Request) throws {
        request.body = .data(try serialize())
        request.headers["Content-Type"] = "application/json"
    }
}
