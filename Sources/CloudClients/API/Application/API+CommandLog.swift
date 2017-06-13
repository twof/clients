extension CloudAPI {
    public func commandLogs(
        for env: ModelOrIdentifier<Environment>,
        on app: ModelOrIdentifier<Application>
    ) throws -> [CommandLog] {
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
        let res = try respond(to: req)
        return try [CommandLog](json: res.assertJSON())
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
