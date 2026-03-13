protocol ReloginService: Sendable {
    func relogin() async throws -> AuthResponse
}