import JWT

/// Access token required for accessing
/// most Vapor Cloud endpoints
public struct AccessToken {
    let jwt: JWT

    public init(string: String) throws {
        self.jwt = try JWT(token: string)
    }

    init(_ jwt: JWT) {
        self.jwt = jwt
    }

    public func makeString() throws -> String {
        return try jwt.createToken()
    }

    public var expirationDate: Date {
        guard let date = jwt.payload["exp"]?.double else {
            return Date()
        }
        return Date(timeIntervalSince1970: date)
    }

    public var isExpired: Bool {
        // check slightly ahead
        let now = Date(timeIntervalSinceNow: 5)
        switch expirationDate.compare(now) {
        case .orderedAscending, .orderedSame:
            return true
        case .orderedDescending:
            return false
        }
    }
}
