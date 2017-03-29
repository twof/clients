import PackageDescription

let package = Package(
    name: "Clients",
    dependencies: [
        // Conveniences for working with models.
        .Package(url: "git@github.com:vapor-cloud/models.git", majorVersion: 0),

        // HTTP, WebSockets, Streams, SMTP, etc.
        .Package(url: "https://github.com/vapor/vapor.git", Version(2,0,0, prereleaseIdentifiers: ["beta"])),

        // JSON Web Tokens in Swift by @siemensikkema.
        .Package(url: "https://github.com/vapor/jwt.git", majorVersion: 0)
    ] 
)
