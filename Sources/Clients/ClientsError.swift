import HTTP

public enum ClientsError: Error {
    case createRequest(Error)
    case connect(Error)
    case badResponse(Status)
}

import Debugging

extension ClientsError: Debuggable {
    public var reason: String {
        switch self {
        case .createRequest(let error):
            return "Could not create the request: \(error)"
        case .connect(let error):
            return "Could not connect to the remote API: \(error)"
        case .badResponse(let status):
            return "Received a bad response status code: \(status)"
        }
    }

    public var identifier: String {
        switch self {
        case .createRequest:
            return "createRequest"
        case .connect:
            return "connect"
        case .badResponse(let status):
            return "badResponse.\(status.statusCode)"
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
        }
    }

    public var suggestedFixes: [String] {
        return []
    }
}
