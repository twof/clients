public protocol TokenCache {
    // MARK: Set
    func setAccessToken(_ accessToken: AccessToken?) throws
    func setRefreshToken(_ refreshToken: RefreshToken?) throws

    // MARK: Get
    func getAccessToken() throws -> AccessToken?
    func getRefreshToken() throws -> RefreshToken?
}
