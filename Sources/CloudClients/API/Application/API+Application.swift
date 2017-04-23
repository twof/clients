extension CloudAPI {
    public func application(withRepoName repoName: String) throws -> Application {
        let req = try makeRequest(.get, path: "application", "applications", repoName)
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }
    
    public func applications(
        projectId: Identifier? = nil,
        gitURL: String? = nil
    ) throws -> [Application] {
        let req = try makeRequest(.get, path: "application", "applications")
        var json = JSON()
        if let projectId = projectId {
            try json.set("projectId", projectId)
        }
        if let gitURL = gitURL {
            try json.set("hosting:gitUrl", gitURL)
        }
        req.json = json
        
        let res = try respond(to: req)
        return try [Application](json: res.assertJSON().get("data"))
    }
}
