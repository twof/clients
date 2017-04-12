import URI
import HTTP
import JWT
import Vapor

public final class ClientFactory<C: Client> {
    public let baseUri: URI
    public let clientType: ClientFactoryProtocol

    public init(
        _ baseUri: URI,
        _ clientType: ClientFactoryProtocol,
        _ apiType: C.Type = C.self
    ) {
        self.baseUri = baseUri
        self.clientType = clientType
    }

    public convenience init(
        baseUrl: String,
        _ clientType: ClientFactoryProtocol,
        _ apiType: C.Type = C.self
    ) throws {
        let uri = try URI(baseUrl)
        self.init(uri, clientType, apiType)
    }

    public func makeClient(using jwt: JWT? = nil) throws -> C {
        let client = try clientType.makeClient(
            hostname: baseUri.hostname,
            port: baseUri.port ?? 443,
            baseUri.scheme.securityLayer()
        )

        return C.init(client, baseUri, jwt)
    }
}

extension String {
    func securityLayer() throws -> SecurityLayer {
        if isSecure {
            return .tls(try EngineClient.defaultTLSContext())
        } else {
            return .none
        }
    }
}
