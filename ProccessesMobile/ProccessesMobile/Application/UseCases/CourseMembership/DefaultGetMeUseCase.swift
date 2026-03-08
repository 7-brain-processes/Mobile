//
//  DefaultGetMeUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct DefaultGetMeUseCase: GetMeUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute() async throws -> User {
        try await repository.getMe()
    }
}
