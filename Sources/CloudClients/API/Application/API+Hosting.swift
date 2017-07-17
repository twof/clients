extension CloudAPI {
    public func hosting(
        for app: ModelOrIdentifier<Application>
    ) throws -> Hosting {
        let req = try makeRequest(
            .get, path: "application", "applications", app.getIdentifier(), "hosting"
        )
        let res = try respond(to: req)
        return try Hosting(json: res.assertJSON())
    }
    
    public func create(
        _ hosting: Hosting
    ) throws -> Hosting {
        let req = try makeRequest(
            .post, path: "application", "applications", hosting.application.getIdentifier(), "hosting"
        )
        req.json = try hosting.makeJSON()
        let res = try respond(to: req)
        return try Hosting(json: res.assertJSON())
    }

    public func update(
        _ hosting: Hosting
    ) throws -> Hosting {
        let req = try makeRequest(
            .patch,
            path:
                "application",
                "applications",
                hosting.application.getIdentifier(),
                "hosting"
        )
        req.json = try hosting.makeJSON()
        let res = try respond(to: req)
        return try Hosting(json: res.assertJSON())
    }
}
