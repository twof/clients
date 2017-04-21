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
        accessToken: JWT,
        refreshToken: String
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

        let jwt = try JWT(token: accessToken)
        return (jwt, refreshToken)
    }
    
    public func refresh(withToken refreshToken: String) throws -> JWT {
        let req = try makeRequest(.get, path: "admin", "refresh")
        req.headers[.authorization] = "Bearer \(refreshToken)"
        
        let res = try respond(to: req)
        return try JWT(token: res.assertJSON().get("accessToken"))
    }
    
    public func user(withId userId: Identifier = Identifier("me")) throws -> User {
        let req = try makeRequest(.get, path: "admin", "users", userId)
        let res = try respond(to: req)
        return try User(json: res.assertJSON())
    }
    
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
}
