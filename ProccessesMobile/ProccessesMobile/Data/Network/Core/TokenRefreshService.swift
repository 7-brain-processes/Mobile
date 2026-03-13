protocol TokenRefreshService: Sendable {
    func refreshToken() async throws -> AuthResponse
}