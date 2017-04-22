/// Use to generate access tokens.
/// Refresh token will be used to regenerate
/// expired access tokens automatically.
public final class AccessTokenFactory {
    public let cloudFactory: CloudAPIFactory
    public let tokenCache: TokenCache

    let refreshToken: RefreshToken
    var accessToken: AccessToken?

    public init(
        _ tokenCache: TokenCache,
        _ cloudFactory: CloudAPIFactory
    ) throws {
        self.tokenCache = tokenCache
        self.cloudFactory = cloudFactory

        // retrieve cached tokens
        guard let refresh = try tokenCache.getRefreshToken() else {
            throw CloudAPIError.noRefreshToken
        }
        self.refreshToken = refresh
        self.accessToken = try tokenCache.getAccessToken()
    }

    public func makeAccessToken() throws -> AccessToken {
        guard let accessToken = self.accessToken, !accessToken.isExpired else {
            let accessToken: AccessToken
            do {
                accessToken = try cloudFactory
                    .makeClient()
                    .refresh(with: refreshToken)
            } catch let error as AbortError where error.status == .forbidden {
                // this refresh token is expired
                try tokenCache.setAccessToken(nil)
                try tokenCache.setRefreshToken(nil)
                throw CloudAPIError.refreshTokenExpired
            }

            try tokenCache.setAccessToken(accessToken)
            self.accessToken = accessToken
            return accessToken
        }

        return accessToken
    }
}
