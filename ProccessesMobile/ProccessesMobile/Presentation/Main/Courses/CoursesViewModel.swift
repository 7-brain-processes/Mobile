//
//  CoursesViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Combine
import Foundation

@MainActor
final class CoursesViewModel: ObservableObject {
    private let getMeUseCase: GetMeUseCase

    private weak var navigator: CoursesNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var courses: [CourseCardItem]
    @Published var currentUserDisplayName: String
    @Published var isLoadingUser: Bool = false
    @Published var errorMessage: String?

    init(
        getMeUseCase: GetMeUseCase,
        navigator: CoursesNavigating,
        appRouter: AppFlowRouting? = nil,
        currentUserDisplayName: String = "User",
        courses: [CourseCardItem] = [
            CourseCardItem(
                id: UUID(),
                name: "Mathematics",
                description: "Linear algebra and analysis",
                isTeacher: true,
                teacherCount: 1,
                studentCount: 24
            ),
            CourseCardItem(
                id: UUID(),
                name: "Physics",
                description: "Mechanics and waves",
                isTeacher: false,
                teacherCount: 2,
                studentCount: 31
            ),
            CourseCardItem(
                id: UUID(),
                name: "Biology",
                description: "Cell structure and genetics",
                isTeacher: false,
                teacherCount: 1,
                studentCount: 18
            )
        ]
    ) {
        self.getMeUseCase = getMeUseCase
        self.navigator = navigator
        self.appRouter = appRouter
        self.currentUserDisplayName = currentUserDisplayName
        self.courses = courses
    }

    var currentUserInitial: String {
        let source = currentUserDisplayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return String(source.prefix(1)).uppercased().isEmpty ? "U" : String(source.prefix(1)).uppercased()
    }

    var teachingCourses: [CourseCardItem] {
        courses.filter(\.isTeacher)
    }

    var attendingCourses: [CourseCardItem] {
        courses.filter { !$0.isTeacher }
    }

    func onAppear() async {
        await loadCurrentUser()
    }

    func loadCurrentUser() async {
        guard !isLoadingUser else { return }

        isLoadingUser = true
        errorMessage = nil
        defer { isLoadingUser = false }

        do {
            let user = try await getMeUseCase.execute()
            currentUserDisplayName = resolvedDisplayName(from: user)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = "Unexpected error"
        }
    }

    func createCourseTapped() {
        navigator?.openCreateCourse()
    }

    func joinByCodeTapped() {
        navigator?.openJoinByCode()
    }

    func courseTapped(id: UUID) {
        navigator?.openCourse(id: id)
    }

    func logoutTapped() {
        appRouter?.showAuth()
    }

    private func resolvedDisplayName(from user: User) -> String {
        if let displayName = user.displayName?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !displayName.isEmpty {
            return displayName
        }

        return user.username
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
