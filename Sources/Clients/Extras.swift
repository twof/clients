import JSON
import HTTP

extension Array where Element: JSONInitializable {
    public init(json: JSON) throws {
        guard let raws = json.node.nodeArray else {
            self = []
            return
        }

        var elements: [Element] = []

        for raw in raws {
            let json = try JSON(node: raw)
            let element = try Element(json: json)
            elements.append(element)
        }

        self = elements
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
