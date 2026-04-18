//
//  JoinByCodeViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation
import Combine

@MainActor
final class JoinByCodeViewModel: ObservableObject {
    private let joinCourseUseCase: JoinCourseUseCase
    private weak var navigator: CoursesNavigating?

    @Published var code: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        joinCourseUseCase: JoinCourseUseCase,
        navigator: CoursesNavigating
    ) {
        self.joinCourseUseCase = joinCourseUseCase
        self.navigator = navigator
    }

    func cancelTapped() {
        guard !isLoading else { return }
        navigator?.dismissSheet()
    }

    func joinTapped() {
        let trimmedCode = code.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedCode.isEmpty else {
            errorMessage = "Course code cannot be empty"
            return
        }

        Task {
            isLoading = true
            errorMessage = nil

            defer { isLoading = false }

            do {
                let course = try await joinCourseUseCase.execute(
                    JoinCourseCodeCommand(code: trimmedCode)
                )

                navigator?.dismissSheet()
                navigator?.openCourse(id: course.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
