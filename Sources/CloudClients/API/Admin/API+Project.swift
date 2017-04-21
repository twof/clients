extension CloudAPI {
    /// Index
    public func projects() throws -> [Project] {
        let req = try makeRequest(.get, path: "projects")
        let res = try respond(to: req)
        return try [Project](
            json: res.assertJSON().get("data")
        )
    }

    /// Show
    public func project(withId projectId: Identifier) throws -> Project {
        let req = try makeRequest(.get, path: "projects", projectId)
        let res = try respond(to: req)
        return try Project(
            json: res.assertJSON()
        )
    }

    /// Store
    public func create(_ project: Project) throws -> Project {
        let orgId = try project.organization.assertIdentifier()
        let req = try makeRequest(.post, path: "organizations", orgId, "projects")
        req.json = try project.makeJSON()
        
        let res = try respond(to: req)
        return try Project(
            json: res.assertJSON()
        )
    }
}
