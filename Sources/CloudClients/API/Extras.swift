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
    public func assertJSON() throws -> JSON {
        guard headers[.contentType]?.contains("application/json") == true else {
            throw CloudAPIError.invalidJSON
        }
        
        guard case .data(let bytes) = body else {
            throw CloudAPIError.invalidJSON
        }
        
        do {
            return try JSON(bytes: bytes)
        } catch {
            throw CloudAPIError.invalidJSON
        }
    }
}
