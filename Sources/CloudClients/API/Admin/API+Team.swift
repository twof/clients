import HTTP
import JWT

extension CloudAPI {
    public func teams(in org: ModelOrIdentifier<Organization>) throws -> [Team] {
        let req = try makeRequest(.get, path: "admin", "organizations", org.assertIdentifier(), "teams")
        let res = try respond(to: req)
        return try [Team](json: res.assertJSON())
    }
    
    public func teams(for proj: ModelOrIdentifier<Project>) throws -> [Team] {
        let req = try makeRequest(.get, path: "admin", "projects", proj.assertIdentifier(), "teams")
        let res = try respond(to: req)
        return try [Team](json: res.assertJSON())
    }
    
    public func team(withId id: Identifier) throws -> Team {
        let req = try makeRequest(.get, path: "admin", "teams", id)
        let res = try respond(to: req)
        return try Team(json: res.assertJSON())
    }
    
    public func create(_ team: Team) throws -> Team {
        let req = try makeRequest(.post, path: "admin", "organizations", team.organization.assertIdentifier(), "teams")
        req.json = try team.makeJSON()
        let res = try respond(to: req)
        return try Team(json: res.assertJSON())
    }
    
    public func attach(_ user: ModelOrIdentifier<User>, to team: ModelOrIdentifier<Team>) throws {
        let req = try makeRequest(
            .post,
            path:
                "admin",
                "teams",
                team.assertIdentifier(),
                "users",
                user.assertIdentifier()
        )
        _ = try respond(to: req)
    }
    
    public func detach(_ user: ModelOrIdentifier<User>, from team: ModelOrIdentifier<Team>) throws {
        let req = try makeRequest(
            .delete,
            path:
            "admin",
            "teams",
            team.assertIdentifier(),
            "users",
            user.assertIdentifier()
        )
        _ = try respond(to: req)
    }
    
    public func projects(for team: ModelOrIdentifier<Team>) throws -> [Project] {
        let req = try makeRequest(.get, path: "admin", "teams", team.assertIdentifier(), "projects")
        req.json = try team.makeJSON()
        let res = try respond(to: req)
        return try [Project](json: res.assertJSON())
    }
    
    public func users(for team: ModelOrIdentifier<Team>) throws -> [User] {
        let req = try makeRequest(.get, path: "admin", "teams", team.assertIdentifier(), "users")
        req.json = try team.makeJSON()
        let res = try respond(to: req)
        return try [User](json: res.assertJSON())
    }
}
