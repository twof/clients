extension CloudAPI {
    // MARK: Project
    
    public func projectPermissions(
        forUserId id: Identifier
    ) throws -> [Identifier: [ProjectPermission]] {
        let req = try makeRequest(.get, path: "admin", "users", id, "permissions", "projects")
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
        userId: Identifier
    ) throws -> [ProjectPermission] {
        let id = try project.assertIdentifier()
        let req = try makeRequest(.get, path: "admin", "users", userId, "permissions", "projects", id)
        let res = try respond(to: req)
        return try [ProjectPermission](
            keysJSON: res.assertJSON()
        )
    }
    
    // MARK: Organization
    
    public func organizationPermissions(
        forUserId id: Identifier
    ) throws -> [Identifier: [OrganizationPermission]] {
        let req = try makeRequest(.get, path: "admin", "users", id, "permissions", "projects")
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
        userId: Identifier
    ) throws -> [OrganizationPermission] {
        let id = try org.assertIdentifier()
        let req = try makeRequest(.get, path: "admin", "users", userId, "permissions", "organizations", id)
        let res = try respond(to: req)
        return try [OrganizationPermission](
            keysJSON: res.assertJSON()
        )
    }
    
    // MARK: All
    
    public func projectPermissions() throws -> [ProjectPermission] {
        let req = try makeRequest(.get, path: "admin", "permissions", "projects")
        let res = try respond(to: req)
        return try [ProjectPermission](
            json: res.assertJSON()
        )
    }
    
    public func organizationPermissions() throws -> [OrganizationPermission] {
        let req = try makeRequest(.get, path: "admin", "permissions", "organizations")
        let res = try respond(to: req)
        return try [OrganizationPermission](
            json: res.assertJSON()
        )
    }
    
    // MARK: Replace
    
    public func replace(_ permissions: [ProjectPermission], for user: User, on project: Project) throws -> [ProjectPermission] {
        let req = try makeRequest(.put, path: "admin", "users", user.id, "permissions", "projects", project.id)
        req.json = permissions.makeKeysJSON()
        let res = try respond(to: req)
        return try [ProjectPermission](
            keysJSON: res.assertJSON()
        )
    }
    
    public func replace(
        _ permissions: [ProjectPermission],
        for team: ModelOrIdentifier<Team>,
        on project: ModelOrIdentifier<Project>
    ) throws -> [ProjectPermission] {
        let req = try makeRequest(
            .put,
            path:
                "admin",
                "teams",
                team.assertIdentifier(),
                "permissions",
                "projects",
                project.assertIdentifier()
        )
        
        req.json = permissions.makeKeysJSON()
        let res = try respond(to: req)
        return try [ProjectPermission](
            keysJSON: res.assertJSON()
        )
    }
    
    public func replace(_ permissions: [OrganizationPermission], for user: User, on org: Organization) throws -> [OrganizationPermission] {
        let req = try makeRequest(.put, path: "admin", "users", user.id, "permissions", "organizations", org.id)
        req.json = permissions.makeKeysJSON()
        let res = try respond(to: req)
        return try [OrganizationPermission](
            keysJSON: res.assertJSON()
        )
    }
    
    // MARK: Invite
    
    public func invite(
        email: String,
        to project: ModelOrIdentifier<Project>? = nil,
        to org: ModelOrIdentifier<Organization>? = nil,
        onAccept acceptURL: String,
        with projPermissions: [ProjectPermission]? = nil,
        with orgPermissions: [OrganizationPermission]? = nil
    ) throws {
        let req = try makeRequest(.post, path: "admin", "users", "invite")
        var json = JSON()
        if let project = project {
            try json.set("project.id", project.getIdentifier())
            if let permissions = projPermissions {
                try json.set("project.permissions", permissions.makeKeysJSON())
            }
        }
        if let org = org {
            try json.set("organization.id", org.getIdentifier())
            if let permissions = orgPermissions {
                try json.set("organization.permissions", permissions.makeKeysJSON())
            }
        }
        try json.set("email", email)
        try json.set("acceptURL", acceptURL)
        req.json = json
        _ = try respond(to: req)
    }
}

extension Identifier: Hashable {
    public var hashValue: Int {
        return (string ?? "").hashValue
    }
}
