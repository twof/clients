extension CloudAPI {
    public func create(_ env: Environment, for app: ModelOrIdentifier<Application>) throws -> Environment {
        let req = try makeRequest(.post, path: "application", "applications", app.getIdentifier(), "hosting", "environments")
        req.json = try env.makeJSON()
        let res = try respond(to: req)
        return try Environment(json: res.assertJSON())
    }
    
    public func environment(
        withId envId: Identifier,
        for app: ModelOrIdentifier<Application>
    ) throws -> Environment {
        let req = try makeRequest(.get, path: "application", "applications", app.getIdentifier(), "hosting", "environments", envId)
        let res = try respond(to: req)
        return try Environment(json: res.assertJSON())
    }
    
    public func environments(
        for app: ModelOrIdentifier<Application>
    ) throws -> [Environment] {
        let req = try makeRequest(.get, path: "application", "applications", app.getIdentifier(), "hosting", "environments")
        let res = try respond(to: req)
        return try [Environment](json: res.assertJSON())
    }
    
    public func deploy(
        environment: ModelOrIdentifier<Environment>,
        application: ModelOrIdentifier<Application>,
        gitBranch: String,
        replicas: Int,
        replicaSize: ReplicaSize,
        method: Deployment.Method
    ) throws -> (Environment, Deployment) {
        let req = try makeRequest(
            .patch,
            path:
                "application",
                "applications",
                application.getIdentifier(),
                "hosting",
                "environments",
                environment.getIdentifier()
        )
        
        var json = JSON()
        try json.set("gitBranch", gitBranch)
        try json.set("replicas", replicas)
        try json.set("replicaSize", replicaSize)
        switch method {
        case .code(let method):
            try json.set("code", method.makeJSON())
        default:
            break
        }
        req.json = json
        
        let res = try respond(to: req).assertJSON()
        return try (
            Environment(json: res),
            Deployment(json: res.get("deployment"))
        )
    }

    public func update(
        _ env: Environment,
        for app: ModelOrIdentifier<Application>
    ) throws -> Environment {
        let req = try makeRequest(
            .patch,
            path:
            "application",
            "applications",
            app.getIdentifier(),
            "hosting",
            "environments",
            env.id
        )

        var json = JSON()
        try json.set("defaultBranch", env.defaultBranch)
        req.json = json

        let res = try respond(to: req).assertJSON()
        return try Environment(json: res)
    }

    public func delete(_ env: ModelOrIdentifier<Environment>, for app: ModelOrIdentifier<Application>) throws {
        let req = try makeRequest(
            .delete,
            path:
                "application",
                "applications",
                app.getIdentifier(),
                "hosting",
                "environments",
                env.getIdentifier()
        )
        _ = try respond(to: req)
    }
}
