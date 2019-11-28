// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "CloudClients",
    dependencies: [
        // Vapor Cloud models.
        .package(url: "https://github.com/twof/models.git", .branch("PackageUpgrade")),

        // HTTP, WebSockets, Streams, SMTP, etc.
        .package(url: "https://github.com/vapor/vapor.git", from: "2.0.0"),

        // JSON Web Tokens in Swift by @siemensikkema.
        .package(url: "https://github.com/vapor/jwt.git", from: "2.0.0")
    ], targets: [
        .target(name: "CloudClients", dependencies: ["CloudModels", "Vapor", "JWT"])
    ]
)
