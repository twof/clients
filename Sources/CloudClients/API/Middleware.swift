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


extension Request {
    public func cloudAPIFactory() throws -> CloudAPIFactory {
        guard let factory = storage[factoryKey] as? CloudAPIFactory else {
            throw CloudAPIError.middlewareNotConfigured
        }
        return factory
    }
}
