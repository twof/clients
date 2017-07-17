extension CloudAPI {
    public func commandLogs(
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>,
        page: Int? = nil,
        size: Int? = nil
    ) throws -> Page<CommandLog> {
        let req = try makeRequest(
            .get,
            path:
            "application",
            "applications",
            app.getIdentifier(),
            "hosting",
            "environments",
            env.getIdentifier(),
            "command-logs"
        )
        var json = JSON()
        if let page = page {
            try json.set("page", page)
        }
        if let size = size {
            try json.set("size", size)
        }
        req.json = json
        let res = try respond(to: req)
        return try .init(json: res.assertJSON())
    }

    public func create(_ log: CommandLog, on app: ModelOrIdentifier<Application>) throws -> CommandLog {
        let req = try makeRequest(
            .post,
            path:
                "application",
                "applications",
                app.getIdentifier(),
                "hosting",
                "environments",
                log.environment.getIdentifier(),
                "command-logs"
        )
        req.json = try log.makeJSON()
        let res = try respond(to: req)
        return try CommandLog(json: res.assertJSON())
    }
}
