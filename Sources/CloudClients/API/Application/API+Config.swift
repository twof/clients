extension CloudAPI {
    public func configurations(
        for env: ModelOrIdentifier<Environment>,
        in app: ModelOrIdentifier<Application>
    ) throws -> [Configuration] {
        let req = try makeRequest(
            .get,
            path: "application", "applications", app.getIdentifier(), "hosting", "environments", env.getIdentifier(), "configurations"
        )
        let res = try respond(to: req)
        return try [Configuration](json: res.assertJSON())
    }
    
    public func update(
        _ configs: [Configuration],
        for env: ModelOrIdentifier<Environment>,
        in app: ModelOrIdentifier<Application>
    ) throws -> [Configuration] {
        let req = try makeRequest(
            .patch,
            path: "application", "applications", app.getIdentifier(), "hosting", "environments", env.getIdentifier(), "configurations"
        )
        req.json = try configs.makeKeysJSON()
        let res = try respond(to: req)
        return try [Configuration](json: res.assertJSON())
    }
    
    public func replace(
        _ configs: [Configuration],
        for env: ModelOrIdentifier<Environment>,
        in app: ModelOrIdentifier<Application>
    ) throws -> [Configuration] {
        let req = try makeRequest(
            .put,
            path: "application", "applications", app.getIdentifier(), "hosting", "environments", env.getIdentifier(), "configurations"
        )
        req.json = try configs.makeKeysJSON()
        let res = try respond(to: req)
        return try [Configuration](json: res.assertJSON())
    }
    
    public func delete(
        _ configs: [Configuration],
        for env: ModelOrIdentifier<Environment>,
        in app: ModelOrIdentifier<Application>
    ) throws -> [Configuration] {
        let req = try makeRequest(
            .delete,
            path: "application", "applications", app.getIdentifier(), "hosting", "environments", env.getIdentifier(), "configurations"
        )
        req.json = try configs.makeKeysArray()
        let res = try respond(to: req)
        return try [Configuration](json: res.assertJSON())
    }
}


extension Array where Iterator.Element == Configuration {
    func makeKeysJSON() throws -> JSON {
        var json = JSON()
        
        try forEach { config in
            try json.set(config.key, config.value)
        }
        
        return json
    }
    
    func makeKeysArray() throws -> JSON {
        var keys: [String] = []
        
        forEach { config in
            keys.append(config.key)
        }
        
        return try JSON(node: keys)
    }
}
