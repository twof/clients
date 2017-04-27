extension CloudAPI {
    /// Index
    public func organizations(
        nameLike name: String? = nil
    ) throws -> [Organization] {
        let req = try makeRequest(.get, path: "admin", "organizations")
        var json = JSON()
        if let name = name {
            try json.set("name", name)
        }
        req.json = json
        
        let res = try respond(to: req)
        return try [Organization](
            json: res.assertJSON().get("data")
        )
    }
    
    /// Show
    public func organization(withId orgId: Identifier) throws -> Organization {
        let req = try makeRequest(.get, path: "admin", "organizations", orgId)
        let res = try respond(to: req)
        
        return try Organization(
            json: res.assertJSON()
        )
    }

    /// Store
    public func create(_ org: Organization) throws -> Organization {
        let req = try makeRequest(.post, path: "admin", "organizations")
        req.json = try org.makeJSON()
        let res = try respond(to: req)
        
        return try Organization(
            json: res.assertJSON()
        )
    }
}
