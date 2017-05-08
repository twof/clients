extension CloudAPI {
    /// Index
    public func projects(
        nameLike name: String? = nil,
        organization: ModelOrIdentifier<Organization>? = nil,
        page: Int? = nil,
        size: Int? = nil
    ) throws -> Page<Project> {
        let req = try makeRequest(.get, path: "admin", "projects")
        var json = JSON()
        if let page = page {
            try json.set("page", page)
        }
        if let size = size {
            try json.set("size", size)
        }
        if let org = organization {
            try json.set("organizationId", org.getIdentifier())
        }
        if let name = name {
            try json.set("name", name)
        }
        req.json = json
        
        let res = try respond(to: req)
        return try Page<Project>(json: res.assertJSON())
    }

    /// Show
    public func project(withId projectId: Identifier) throws -> Project {
        let req = try makeRequest(.get, path: "admin", "projects", projectId)
        let res = try respond(to: req)
        return try Project(
            json: res.assertJSON()
        )
    }

    /// Store
    public func create(_ project: Project) throws -> Project {
        let orgId = try project.organization.assertIdentifier()
        let req = try makeRequest(.post, path: "admin", "organizations", orgId, "projects")
        req.json = try project.makeJSON()
        
        let res = try respond(to: req)
        return try Project(
            json: res.assertJSON()
        )
    }
    
    public func destroy(_ project: ModelOrIdentifier<Project>) throws {
        let req = try makeRequest(.delete, path: "admin", "projects", project.assertIdentifier())
        _ = try respond(to: req)
    }
}


// Represents a page of results for the entity
public struct Page<E: JSONConvertible> {
    public let number: Int
    public let data: [E]
    public let size: Int
    public let total: Int
    
    // The query used must already be filtered for
    // pagination and ready for `.all()` call
    public init(
        number: Int,
        data: [E],
        size: Int,
        total: Int
    ) throws {
        self.number = number
        self.data = data
        self.size = size
        self.total = total
    }
}

extension Page: JSONInitializable {
    public init(json: JSON) throws {
        try self.init(
            number: json.get("page.position.current"),
            data: [E](json: json.get("data")),
            size: json.get("page.data.per"),
            total: json.get("page.data.total")
        )
    }
}

extension Page: JSONRepresentable {
    public func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("number", number)
        try json.set("data", data.makeJSON())
        try json.set("size", size)
        try json.set("total", total)
        return json
    }
}
