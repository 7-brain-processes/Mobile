//
//  CreateCourseViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation
import Combine

@MainActor
final class CreateCourseViewModel: ObservableObject {
    private let createCourseUseCase: CreateCourseUseCase
    private weak var navigator: CoursesNavigating?

    @Published var courseName: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        createCourseUseCase: CreateCourseUseCase,
        navigator: CoursesNavigating
    ) {
        self.createCourseUseCase = createCourseUseCase
        self.navigator = navigator
    }

    func cancelTapped() {
        guard !isLoading else { return }
        navigator?.dismissSheet()
    }

    func finishTapped() {
        let trimmedName = courseName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            errorMessage = "Course name cannot be empty"
            return
        }
        Task {
            isLoading = true
            errorMessage = nil

            defer { isLoading = false }

            do {
                let course = try await createCourseUseCase.execute(
                    CreateCourseCommand(
                        name: trimmedName,
                        description: ""
                    )
                )

                navigator?.dismissSheet()
                navigator?.openCourse(id: course.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
