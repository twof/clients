extension CloudAPI {
    public func create(
        _ deployment: Deployment
    ) throws -> Deployment {
        let req = try makeRequest(.post, path: "deploy", "deployments")
        req.json = try deployment.makeJSON()
        let res = try respond(to: req)
        return try Deployment(json: res.assertJSON())
    }

    public func update(
        deploymentId: Node,
        status: Deployment.Status? = nil,
        logMsg: String? = nil
    ) throws -> Deployment {
        var json = JSON([:])
        try json.set("status", status)
        try json.set("logMsg", logMsg)
        
        let req = try makeRequest(.post, path: "deploy", "deployments", deploymentId)
        req.json = json
        
        let res = try respond(to: req)

        return try Deployment(json: res.assertJSON())
    }
}
