extension CloudAPI {
    public func create(_ env: Environment, for app: ModelOrIdentifier<Application>) throws -> Environment {
        let req = try makeRequest(.post, path: "application", "applications", app.getIdentifier(), "hosting", "environments")
        req.json = try env.makeJSON()
        let res = try respond(to: req)
        return try Environment(json: res.assertJSON())
    }
}
