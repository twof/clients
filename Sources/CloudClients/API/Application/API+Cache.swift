extension CloudAPI {
    public func cacheServers() throws -> [CacheServer] {
        let req = try makeRequest(.get, path: "application", "cache-servers")
        let res = try respond(to: req)
        return try [CacheServer](json: res.assertJSON())
    }
    
    public func cacheServer(withId id: Identifier) throws -> CacheServer {
        let req = try makeRequest(.get, path: "application", "cache-servers", id)
        let res = try respond(to: req)
        return try CacheServer(json: res.assertJSON())
    }
    
    public func cache(
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>
    ) throws -> Cache {
        let req = try makeRequest(.get, path:
            "application",
            "applications",
            app.getIdentifier(),
            "hosting",
            "environments",
            env.getIdentifier(),
            "cache"
        )
        
        let res = try respond(to: req)
        return try Cache(json: res.assertJSON())
    }
    
    public func create(
        _ cache: Cache,
        for app: ModelOrIdentifier<Application>
    ) throws -> Cache {
        let req = try makeRequest(.post, path:
            "application",
            "applications",
            app.getIdentifier(),
            "hosting",
            "environments",
            cache.environment.getIdentifier(),
            "cache"
        )
        req.json = try cache.makeJSON()
        let res = try respond(to: req)
        return try Cache(json: res.assertJSON())
    }
}
