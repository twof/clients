extension CloudAPI {
    // MARK: Project
    
    public func projectPermissions(
        forUserId id: Identifier = Identifier("me")
    ) throws -> [Identifier: [ProjectPermission]] {
        let req = try makeRequest(.get, path: "users", id, "permissions", "projects")
        let res = try respond(to: req)

        guard let object = res.json?.object else {
            return [:]
        }
        
        var result: [Identifier: [ProjectPermission]] = [:]
        
        for (key, value) in object {
            result[Identifier(key)] = [ProjectPermission](keysJSON: value)
        }
        
        return result
    }
    
    public func permissions(
        for project: ModelOrIdentifier<Project>,
        userId: Identifier = Identifier("me")
    ) throws -> [ProjectPermission] {
        let id = try project.assertIdentifier()
        let req = try makeRequest(.get, path: "users", userId, "permissions", "projects", id)
        let res = try respond(to: req)
        return try [ProjectPermission](
            keysJSON: res.assertJSON()
        )
    }
    
    // MARK: Organization
    
    public func organizationPermissions(
        forUserId id: Identifier = Identifier("me")
    ) throws -> [Identifier: [OrganizationPermission]] {
        let req = try makeRequest(.get, path: "users", id, "permissions", "projects")
        let res = try respond(to: req)
        
        guard let object = res.json?.object else {
            return [:]
        }
        
        var result: [Identifier: [OrganizationPermission]] = [:]
        
        for (key, value) in object {
            result[Identifier(key)] = [OrganizationPermission](keysJSON: value)
        }
        
        return result
    }

    public func permissions(
        for org: ModelOrIdentifier<Organization>,
        userId: Identifier = Identifier("me")
    ) throws -> [OrganizationPermission] {
        let id = try org.assertIdentifier()
        let req = try makeRequest(.get, path: "users", userId, "permissions", "organizations", id)
        let res = try respond(to: req)
        return try [OrganizationPermission](
            keysJSON: res.assertJSON()
        )
    }
}

extension Identifier: Hashable {
    public var hashValue: Int {
        return (string ?? "").hashValue
    }
}
