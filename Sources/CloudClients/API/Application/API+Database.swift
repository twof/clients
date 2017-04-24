extension CloudAPI {
    public func databaseServers() throws -> [DatabaseServer] {
        let req = try makeRequest(.get, path: "application", "database-servers")
        let res = try respond(to: req)
        return try [DatabaseServer](json: res.assertJSON())
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
}
