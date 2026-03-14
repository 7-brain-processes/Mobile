//
//  DefaultSubmitSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//


import Foundation

struct DefaultSubmitSolutionUseCase: SubmitSolutionUseCase {

    private let repository: SolutionRepository

    init(repository: SolutionRepository) {
        self.repository = repository
    }

    func execute(_ command: SubmitSolutionCommand) async throws -> Solution {

        let normalizedText =
            command.text?
                .trimmingCharacters(in: .whitespacesAndNewlines)

        if let text = normalizedText, text.count > 10_000 {
            throw SolutionValidationError.invalidTextLength(max: 10_000)
        }

        let normalizedCommand = SubmitSolutionCommand(
            courseId: command.courseId,
            postId: command.postId,
            text: normalizedText
        )

        return try await repository.submitSolution(normalizedCommand)
    }
}
