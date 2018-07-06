extension CloudAPI {
    /// Index
    public func organizations(
        nameLike name: String? = nil,
        page: Int? = nil,
        size: Int? = nil
    ) throws -> Page<Organization> {
        let req = try makeRequest(.get, path: "admin", "organizations")
        var json = JSON()
        if let page = page {
            try json.set("page", page)
        }
        if let size = size {
            try json.set("size", size)
        }
        if let name = name {
            try json.set("name", name)
        }
        req.json = json
        
        let res = try respond(to: req)
        //return try Page<Project>(json: res.assertJSON())
        return try Page<Organization>(
            json: res.assertJSON()
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
