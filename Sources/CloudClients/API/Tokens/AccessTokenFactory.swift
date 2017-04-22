/// Use to generate access tokens.
/// Refresh token will be used to regenerate
/// expired access tokens automatically.
public final class AccessTokenFactory {
    public let refreshToken: RefreshToken

    var currentAccessToken: AccessToken?
    let cloudFactory: CloudAPIFactory

    public init(
        _ refreshToken: RefreshToken,
        _ cloudFactory: CloudAPIFactory,
        current: AccessToken? = nil
    ) {
        self.refreshToken = refreshToken
        self.cloudFactory = cloudFactory
        self.currentAccessToken = current
    }

    public func makeAccessToken() throws -> AccessToken {
        guard let accessToken = currentAccessToken, !accessToken.isExpired else {
            let accessToken = try cloudFactory
                .makeClient()
                .refresh(with: refreshToken)

            currentAccessToken = accessToken
            return accessToken
        }

        return accessToken
    }
}

