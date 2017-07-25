extension CloudAPI {
    public func application(withRepoName repoName: String) throws -> Application {
        let req = try makeRequest(.get, path: "application", "applications", repoName)
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }
    
    public func applications(
        projectId: Identifier,
        nameLike name: String? = nil,
        repoNameLike repoName: String? = nil,
        page: Int? = nil,
        size: Int? = nil
    ) throws -> Page<Application> {
        let req = try makeRequest(.get, path: "application", "applications")
        var json = JSON()
        if let page = page {
            try json.set("page", page)
        }
        if let size = size {
            try json.set("size", size)
        }
        try json.set("projectId", projectId)
        if let name = name {
            try json.set("name", name)
        }
        if let repoName = repoName {
            try json.set("repoName", repoName)
        }
        req.json = json
        
        let res = try respond(to: req)
        return try Page<Application>(
            json: res.assertJSON()
        )
    }
    
    public func applications(withGitURL gitURL: String) throws -> Application {
        let req = try makeRequest(.get, path: "application", "applications")
        var json = JSON()
        try json.set("hosting:gitUrl", gitURL)
        req.json = json
        
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }
    
    public func create(_ app: Application) throws -> Application {
        let req = try makeRequest(.post, path: "application", "applications")
        req.json = try app.makeJSON()
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }

    public func update(_ app: Application) throws -> Application {
        let req = try makeRequest(.patch, path: "application", "applications", app.assertIdentifier())
        req.json = try app.makeJSON()
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }

    public func delete(_ app: Application) throws {
        let req = try makeRequest(.delete, path: "application", "applications", app.assertIdentifier())
        _ = try respond(to: req)
    }
}
