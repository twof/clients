extension CloudAPI {
    public func domains(
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>
    ) throws -> [Domain] {
        let req = try makeRequest(
            .get, path:
                "application",
                "applications",
                app.assertIdentifier(),
                "hosting",
                "environments",
                env.assertIdentifier(),
                "domains"
        )
        let res = try respond(to: req)
        return try [Domain](json: res.assertJSON())
    }
    
    public func domain(
        withId id: Identifier,
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>
    ) throws -> Domain {
        let req = try makeRequest(
            .get, path:
                "application",
                "applications",
                app.assertIdentifier(),
                "hosting",
                "environments",
                env.assertIdentifier(),
                "domains",
                id
        )
        let res = try respond(to: req)
        return try Domain(json: res.assertJSON())
    }
    
    public func create(
        _ domain: Domain,
        on app: ModelOrIdentifier<Application>
    ) throws -> Domain {
        let req = try makeRequest(
            .post, path:
                "application",
                "applications",
                app.assertIdentifier(),
                "hosting",
                "environments",
                domain.environment.assertIdentifier(),
                "domains"
        )
        req.json = try domain.makeJSON()
        let res = try respond(to: req)
        return try Domain(json: res.assertJSON())
    }
}
