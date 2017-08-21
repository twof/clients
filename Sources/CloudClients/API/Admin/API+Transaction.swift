extension CloudAPI {
    /// Index
    public func transactions(
        organization: ModelOrIdentifier<Organization>,
        page: Int? = nil,
        size: Int? = nil,
        project: ModelOrIdentifier<Project>?,
        application: ModelOrIdentifier<Application>?,
        environment: ModelOrIdentifier<Environment>?
    ) throws -> Page<Transaction> {
        let req = try makeRequest(.get, path: "admin", "transactions")
        var json = JSON()
        if let page = page {
            try json.set("page", page)
        }
        if let size = size {
            try json.set("size", size)
        }
        try json.set("organizationId", organization.getIdentifier())

        if let project = project {
            try json.set("projectId", project.getIdentifier())
        }

        if let application = application {
            try json.set("applicationId", application.getIdentifier())
        }

        if let environment = environment {
            try json.set("environmentId", environment.getIdentifier())
        }

        req.json = json

        let res = try respond(to: req)
        return try Page<Transaction>(json: res.assertJSON())
    }

    /// Show
    public func transaction(withId transactionId: Identifier) throws -> Transaction {
        let req = try makeRequest(.get, path: "admin", "transactions", transactionId)
        let res = try respond(to: req)
        return try Transaction(
            json: res.assertJSON()
        )
    }
}
