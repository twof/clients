import URI
import HTTP
import JWT
import Vapor

public final class CloudAPIFactory {
    public let baseURI: URI
    public let clientType: ClientFactoryProtocol

    public init(
        _ baseURI: URI,
        _ clientType: ClientFactoryProtocol
    ) {
        self.baseURI = baseURI
        self.clientType = clientType
    }

    public convenience init(
        baseURL: String,
        _ clientType: ClientFactoryProtocol
    ) throws {
        let uri = try URI(baseURL)
        self.init(uri, clientType)
    }

    public func makeClient(
        using accessTokenFactory: AccessTokenFactory? = nil
    ) throws -> CloudAPI {
        let client = try clientType.makeClient(
            hostname: baseURI.hostname,
            port: baseURI.port ?? 443,
            securityLayer: baseURI.scheme.securityLayer()
        )
        return CloudAPI(client, baseURI, accessTokenFactory)
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
