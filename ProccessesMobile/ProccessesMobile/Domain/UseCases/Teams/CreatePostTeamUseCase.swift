//
//  CreatePostTeamUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

protocol CreatePostTeamUseCase: Sendable {
    func execute(_ command: CreatePostTeamCommand) async throws -> CourseTeamAvailability
}
