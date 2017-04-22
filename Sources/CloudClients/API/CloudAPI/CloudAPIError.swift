import HTTP

public enum CloudAPIError: Error {
    case createRequest(Error)
    case connect(Error)
    case badResponse(ResponseError)
    case middlewareNotConfigured
    case invalidJSON
}

public struct ResponseError {
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
        case .badResponse(let status):
            return "Received a bad response status code: \(status)"
        case .middlewareNotConfigured:
            return "Cloud API middleware is not properly configured"
        case .invalidJSON:
            return "Invalid JSON response from Cloud API"
        }
    }

    public var identifier: String {
        switch self {
        case .createRequest:
            return "createRequest"
        case .connect:
            return "connect"
        case .badResponse(let error):
            return "badResponse.\(error.status.statusCode)"
        case .middlewareNotConfigured:
            return "middlewareNotConfigured"
        case .invalidJSON:
            return "middlewareNotConfigured"
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
        case .badResponse:
            return [
                "Incorrect content was sent to the remote API",
                "The remote API is currently not available"
            ]
        default:
            return []
        }
    }

    public var suggestedFixes: [String] {
        return []
    }
}
