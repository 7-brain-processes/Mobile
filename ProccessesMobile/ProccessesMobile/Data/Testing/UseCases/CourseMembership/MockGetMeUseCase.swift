//
//  MockGetMeUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//
import Foundation

final class MockGetMeUseCase: GetMeUseCase {
    var result: Result<User, Error>?

    func execute() async throws -> User {
        guard let result else {
            fatalError("MockGetMeUseCase.result was not set")
        }

        return try result.get()
    }
}
