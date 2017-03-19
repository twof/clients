import JSON
import HTTP

extension Array where Element: JSONInitializable {
    public init(json: JSON) throws {
        guard let array = json.array else {
            self = []
            return
        }

        self = try array.map { try Element(json: $0) }
    }
}

extension Message {
    public func json() throws -> JSON {
        guard headers[.contentType]?.contains("application/json") == true else {
            return JSON([:])
        }

        guard case .data(let bytes) = body else {
            return JSON([:])
        }

        return try JSON(bytes: bytes)
    }
}
