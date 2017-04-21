import HTTP


private let factoryKey = "cloud-clients:api-factory"

public final class CloudAPIMiddleware: Middleware {
    let factory: CloudAPIFactory
    public init(_ factory: CloudAPIFactory) {
        self.factory = factory
    }
    
    public func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        request.storage[factoryKey] = factory
        return try next.respond(to: request)
    }
}

// MARK: HTTP

extension Request {
    public func cloudAPIFactory() throws -> CloudAPIFactory {
        guard let factory = storage[factoryKey] as? CloudAPIFactory else {
            throw CloudAPIError.middlewareNotConfigured
        }
        return factory
    }
}

// MARK: Config

extension CloudAPIMiddleware: ConfigInitializable {
    public convenience init(config: Config) throws {
        guard let cloud = config["cloud"] else {
            throw ConfigError.missingFile("cloud")
        }
        
        guard let url = cloud["url"]?.string else {
            throw ConfigError.missing(key: ["url"], file: "cloud", desiredType: String.self)
        }
        
        let client = try config.resolveClient()
        let factory = try CloudAPIFactory(baseURL: url, client)
        
        self.init(factory)
    }
}
