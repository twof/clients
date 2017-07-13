import HTTP
import JWT

extension CloudAPI {
    public func createUser(
        name: Name,
        email: String,
        password: String,
        organizationName: String? = nil,
        inviteToken: JWT? = nil
    ) throws -> User {
        var json = JSON([:])
        try json.set("name", name.makeJSON())
        try json.set("email", email)
        try json.set("password", password)
        
        if let name = organizationName {
            try json.set("organization.name", name)
        }
        
        if let inviteToken = inviteToken {
            try json.set("inviteToken", inviteToken.createToken())
        }
        
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
        req.headers[.authorization] = "Bearer \(refreshToken.makeString())"
        
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
    
    public func user(withEmail email: String) throws -> User? {
        let _req = try makeRequest(.get, path: "admin", "users")
        var uri = _req.uri
        uri.query = "email=\(email)"
        let req = Request(method: .get, uri: uri)
        req.headers = _req.headers
        
        do  {
            let res = try respond(to: req)
            return try User(json: res.assertJSON())
        } catch let error as AbortError where error.status == .notFound {
            return nil
        }
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
    
    // MARK: Password Reset
    
    public func requestPasswordReset(for email: String, acceptURL: String) throws {
        let req = try makeRequest(.post, path: "admin", "passwords", "resets")
        req.json = try JSON(node: [
            "email": email,
            "acceptURL": acceptURL
        ])
        _ = try respond(to: req)
    }
    
    public func resetPassword(to password: String, using token: String) throws {
        let req = try makeRequest(.post, path: "admin", "passwords")
        req.json = try JSON(node: [
            "password": password,
            "token": token
        ])
        _ = try respond(to: req)
    }
}
