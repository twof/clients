import HTTP

public enum CloudAPIError: Error {
    case createRequest(Error)
    case connect(Error)
    case middlewareNotConfigured
    case invalidJSON
    case noRefreshToken
    case refreshTokenExpired
}

public struct ResponseError: AbortError {
    public let status: Status
    public let reason: String
}

import Debugging

extension CloudAPIError: Debuggable {
    public var reason: String {
        switch self {
        case .createRequest(let error):
            return "Could not create the request: \(error)"
        case .connect(let error):
            return "Could not connect to the remote API: \(error)"
        case .middlewareNotConfigured:
            return "Cloud API middleware is not properly configured"
        case .invalidJSON:
            return "Invalid JSON response from Cloud API"
        case .noRefreshToken:
            return "No cached refresh token was found"
        case .refreshTokenExpired:
            return "The refresh token has expired"
        }
    }

    public var identifier: String {
        switch self {
        case .createRequest:
            return "createRequest"
        case .connect:
            return "connect"
        case .middlewareNotConfigured:
            return "middlewareNotConfigured"
        case .invalidJSON:
            return "middlewareNotConfigured"
        case .noRefreshToken:
            return "noRefreshToken"
        case .refreshTokenExpired:
            return "refreshTokenExpired"
        }
    }

    public var possibleCauses: [String] {
        switch self {
        case .createRequest:
            return [
                "You are attempting to create a client with an invalid baseUrl",
                "An invalid JWT was used"
            ]
        case .connect:
            return [
                "The URL used is invalid",
                "The remote API is currently not available"
            ]
        default:
            return []
        }
    }

    public var suggestedFixes: [String] {
        switch self {
        case .refreshTokenExpired:
            return ["Login again"]
        default:
            return []
        }
    }
}
