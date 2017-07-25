extension CloudAPI {
    public func databaseServers() throws -> [DatabaseServer] {
        let req = try makeRequest(.get, path: "application", "database-servers")
        let res = try respond(to: req)
        return try [DatabaseServer](json: res.assertJSON())
    }
    
    public func databaseServer(withId id: Identifier) throws -> DatabaseServer {
        let req = try makeRequest(.get, path: "application", "database-servers", id)
        let res = try respond(to: req)
        return try DatabaseServer(json: res.assertJSON())
    }
    
    public func database(
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>
    ) throws -> Database {
        let req = try makeRequest(
            .get,
            path:
                "application",
                "applications",
                app.getIdentifier(),
                "hosting",
                "environments",
                env.getIdentifier(),
                "database"
        )
        
        let res = try respond(to: req)
        return try Database(json: res.assertJSON())
    }
    
    public func create(
        _ database: Database,
        for app: ModelOrIdentifier<Application>
    ) throws -> Database {
        let req = try makeRequest(.post, path:
            "application",
            "applications",
            app.getIdentifier(),
            "hosting",
            "environments",
            database.environment.getIdentifier(),
            "database"
        )
        req.json = try database.makeJSON()
        let res = try respond(to: req)
        return try Database(json: res.assertJSON())
    }

    public func deleteDatabase(
        on env: ModelOrIdentifier<Environment>,
        for app: ModelOrIdentifier<Application>
    ) throws {
        let req = try makeRequest(.delete, path:
            "application",
            "applications",
            app.getIdentifier(),
            "hosting",
            "environments",
            env.getIdentifier(),
            "database"
        )
        let _ = try respond(to: req)
    }
    
    public func makePMAUrl(
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>
    ) throws -> String? {
        guard let token = try accessTokenFactory?.makeAccessToken() else {
            return nil
        }
        
        return try "\(baseURI)/application/applications/\(app.assertIdentifier())/hosting/environments/\(env.assertIdentifier())/database/pma?_authorizationBearer=\(token.makeString())"
    }
}
