import HTTP

extension CloudAPI {
    public func assert(
        can required: ProjectPermission,
        project: ModelOrIdentifier<Project>
    ) throws {
        let permissions = try self.permissions(for: project, userId: Identifier("me"))

        var found = false

        for permission in permissions {
            if permission.key == required.key {
                found = true
                break
            }
        }

        guard found else {
            throw Status.unauthorized
        }
    }
    
    public func assert(
        can required: OrganizationPermission,
        organization: ModelOrIdentifier<Organization>
    ) throws {
        let permissions = try self.permissions(for: organization, userId: Identifier("me"))
        
        var found = false
        
        for permission in permissions {
            if permission.key == required.key {
                found = true
                break
            }
        }
        
        guard found else {
            throw Status.unauthorized
        }
    }
}
