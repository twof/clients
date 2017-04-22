/// Refresh tokens are used for generating
/// access tokens without user credentials.
public struct RefreshToken {
    let string: String
    public init(string: String) {
        self.string = string
    }

    public func makeString() -> String {
        return string
    }
}
