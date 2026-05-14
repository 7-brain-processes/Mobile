//
//  CreatePostViewModel.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation
import Combine

@MainActor
final class CreatePostViewModel: ObservableObject {
    private let createPostUseCase: CreatePostUseCase
    private let courseId: UUID

    @Published var title: String = ""
    @Published var content: String = ""
    @Published var deadline: Date = .now
    @Published var selectedFileURLs: [URL] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let initialType: FeedPostType

    init(
        courseId: UUID,
        initialType: FeedPostType,
        createPostUseCase: CreatePostUseCase
    ) {
        self.courseId = courseId
        self.initialType = initialType
        self.createPostUseCase = createPostUseCase
    }

    var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    func createTapped() async -> Bool {
        guard !isLoading else { return false }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            _ = try await createPostUseCase.execute(
                CreatePostCommand(
                    courseId: courseId,
                    title: title,
                    content: normalizedContent(),
                    type: mapFeedPostType(initialType),
                    deadline: initialType == .task ? deadline : nil
                )
            )

            return true
        } catch let error as PostValidationError {
            errorMessage = mapPostValidationError(error)
            return false
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
            return false
        } catch {
            errorMessage = "Unexpected error"
            return false
        }
    }

    private func normalizedContent() -> String? {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func mapFeedPostType(_ type: FeedPostType) -> PostType {
        switch type {
        case .task:
            return .task
        case .material:
            return .material
        }
    }

    private func mapPostValidationError(_ error: PostValidationError) -> String {
        switch error {
        case .invalidTitleLength(let min, let max):
            return "Заголовок должен быть от \(min) до \(max) символов"
        case .invalidContentLength(let max):
            return "Описание не должно превышать \(max) символов"
        case .emptyCourseId:
            return "Нет курса"
        case .emptyPostId:
            return "Нет поста"
        }
    }

    private func mapAPIError(_ error: APIError) -> String {
        switch error {
        case .unauthorized:
            return "Сессия истекла"
        case .serverError(let code):
            return "Ошибка сервера: \(code)"
        case .invalidResponse:
            return "Некорректный ответ сервера"
        case .underlying:
            return "Ошибка сети"
        case .invalidURL:
            return "Ошибка URL"
        }
    }
}
