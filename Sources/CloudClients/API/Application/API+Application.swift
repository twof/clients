extension CloudAPI {
    public func application(withRepoName repoName: String) throws -> Application {
        let req = try makeRequest(.get, path: "application", "applications", repoName)
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }
    
    public func applications(projectId: Identifier) throws -> [Application] {
        let req = try makeRequest(.get, path: "application", "applications")
        var json = JSON()
        try json.set("projectId", projectId)
        req.json = json
        
        let res = try respond(to: req)
        return try [Application](json: res.assertJSON().get("data"))
    }
}
