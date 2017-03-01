import URI
import HTTP
import JWT

public final class ClientFactory<C: Client> {
    public let baseUri: URI
    public let clientType: ClientProtocol.Type

    public init(
        _ baseUri: URI,
        _ clientType: ClientProtocol.Type,
        _ apiType: C.Type = C.self
    ) {
        self.baseUri = baseUri
        self.clientType = clientType
    }

    public convenience init(
        baseUrl: String,
        _ clientType: ClientProtocol.Type,
        _ apiType: C.Type = C.self
    ) throws {
        let uri = try URI(baseUrl)
        self.init(uri, clientType, apiType)
    }

    public func makeClient(using jwt: JWT? = nil) throws -> C {
        let client = try clientType.init(
            scheme: baseUri.scheme,
            host: baseUri.host,
            port: baseUri.port ?? 443,
            securityLayer: baseUri.scheme.securityLayer,
            middleware: []
        )

        return C.init(client, jwt)
    }
}
