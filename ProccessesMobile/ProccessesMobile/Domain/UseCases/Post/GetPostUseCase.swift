//
//  GetPostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol GetPostUseCase: Sendable {
    func execute(courseId: UUID, postId: UUID) async throws -> Post
}
