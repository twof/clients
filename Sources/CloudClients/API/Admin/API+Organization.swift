extension CloudAPI {
    /// Show
    public func organization(withId orgId: Identifier) throws -> Organization {
        let req = try makeRequest(.get, path: "organizations", orgId)
        let res = try respond(to: req)
        
        return try Organization(
            json: res.assertJSON()
        )
    }

    /// Store
    public func create(_ org: Organization) throws -> Organization {
        let req = try makeRequest(.post, path: "organizations")
        req.json = try org.makeJSON()
        let res = try respond(to: req)
        
        return try Organization(
            json: res.assertJSON()
        )
    }
}
