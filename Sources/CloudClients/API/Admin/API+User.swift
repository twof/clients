import HTTP
import JWT

extension CloudAPI {
    public func createUser(
        name: Name,
        email: String,
        password: String
    ) throws -> User {
        var json = JSON([:])
        try json.set("name", name.makeJSON())
        try json.set("email", email)
        try json.set("password", password)
        
        let req = try makeRequest(.post, path: "admin", "users")
        req.json = json

        let res = try respond(to: req)
        return try User(json: res.assertJSON())
    }

    public func login(
        email: String,
        password: String
    ) throws -> (
        accessToken: AccessToken,
        refreshToken: RefreshToken
    ) {
        let res: Response
        do {
            var json = JSON([:])
            try json.set("email", email)
            try json.set("password", password)
            
            let req = try makeRequest(.post, path: "admin", "login")
            req.json = json
            
            res = try respond(to: req)
        }
        
        let json = try res.assertJSON()

        guard
            let accessToken = json["accessToken"]?.string,
            let refreshToken = json["refreshToken"]?.string
        else {
            print("Malformed Admin API login response.")
            throw Status.internalServerError
        }

        return try (
            AccessToken(string: accessToken),
            RefreshToken(string: refreshToken)
        )
    }
    
    public func refresh(with refreshToken: RefreshToken) throws -> AccessToken {
        let req = try makeRequest(.get, path: "admin", "refresh")
        req.headers[.authorization] = "Bearer \(refreshToken)"
        
        let res = try respond(to: req)
        return try AccessToken(
            string: res.assertJSON().get("accessToken")
        )
    }
    
    public func user(withId userId: Identifier = Identifier("me")) throws -> User {
        let req = try makeRequest(.get, path: "admin", "users", userId)
        let res = try respond(to: req)
        return try User(json: res.assertJSON())
    }
    
    // MARK: Projs / Orgs
    
    public func users(for project: Project) throws -> [User] {
        let req = try makeRequest(.get, path: "admin", "projects", project.id, "users")
        let res = try respond(to: req)
        
        return try [User](json: res.assertJSON())
    }
    
    public func users(for org: Organization) throws -> [User] {
        let req = try makeRequest(.get, path: "admin", "organizations", org.id, "users")
        let res = try respond(to: req)
        
        return try [User](json: res.assertJSON())
    }
    
    // MARK: Prefs
    
    public func preferences(for user: User) throws -> [String: String] {
        let req = try makeRequest(.get, path: "admin", "users", "me", "preferences")
        let res = try respond(to: req)
        return try res.assertJSON().get(".")
    }
    
    public func modifyPreferences(_ preferences: [String: String], for user: User) throws -> [String: String] {
        let req = try makeRequest(.patch, path: "admin", "users", "me", "preferences")
        req.json = try JSON(node: preferences)
        let res = try respond(to: req)
        return try res.assertJSON().get(".")
    }
    
    public func replacePreferences(_ preferences: [String: String], for user: User) throws -> [String: String] {
        let req = try makeRequest(.put, path: "admin", "users", "me", "preferences")
        req.json = try JSON(node: preferences)
        let res = try respond(to: req)
        return try res.assertJSON().get(".")
    }
    
    public func deletePreferences(_ preferences: [String], for user: User) throws {
        let req = try makeRequest(.delete, path: "admin", "users", "me", "preferences")
        req.json = try JSON(node: preferences)
        _ = try respond(to: req)
    }
}
