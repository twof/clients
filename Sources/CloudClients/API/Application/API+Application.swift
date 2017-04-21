extension CloudAPI {
    public func application(withRepoName repoName: String) throws -> Application {
        let req = try makeRequest(.get, path: "applications", repoName)
        let res = try respond(to: req)
        return try Application(json: res.assertJSON())
    }
}
