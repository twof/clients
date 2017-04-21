import HTTP

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
        
        let req = try makeRequest(.post, path: "users")
        req.json = json

        let res = try respond(to: req)
        return try User(json: res.assertJSON())
    }

    public func login(
        email: String,
        password: String
    ) throws -> (
        accessToken: String,
        refreshToken: String
    ) {
        let res: Response
        do {
            var json = JSON([:])
            try json.set("email", email)
            try json.set("password", password)
            
            let req = try makeRequest(.post, path: "login")
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

        return (accessToken, refreshToken)
    }
}
