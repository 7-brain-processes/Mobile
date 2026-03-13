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
    private let getMyCoursesUseCase: GetMyCoursesUseCase

    private weak var navigator: CoursesNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var courses: [CourseCardItem]
    @Published var currentUserDisplayName: String
    @Published var isLoading: Bool
    @Published var errorMessage: String?

    init(
        getMeUseCase: GetMeUseCase,
        getMyCoursesUseCase: GetMyCoursesUseCase,
        navigator: CoursesNavigating,
        appRouter: AppFlowRouting? = nil,
        currentUserDisplayName: String = "User",
        courses: [CourseCardItem] = [],
        isLoading: Bool = false
    ) {
        self.getMeUseCase = getMeUseCase
        self.getMyCoursesUseCase = getMyCoursesUseCase
        self.navigator = navigator
        self.appRouter = appRouter
        self.currentUserDisplayName = currentUserDisplayName
        self.courses = courses
        self.isLoading = isLoading
    }

    var currentUserInitial: String {
        let source = currentUserDisplayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let initial = String(source.prefix(1)).uppercased()
        return initial.isEmpty ? "U" : initial
    }

    var teachingCourses: [CourseCardItem] {
        courses.filter(\.isTeacher)
    }

    var attendingCourses: [CourseCardItem] {
        courses.filter { !$0.isTeacher }
    }

    func onAppear() async {
        await loadInitialData()
    }

    func loadInitialData() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let userTask = getMeUseCase.execute()
            async let coursesTask = getMyCoursesUseCase.execute(
                GetMyCoursesQuery(
                    page: 0,
                    size: 100,
                    role: nil
                )
            )

            let user = try await userTask
            let coursesPage = try await coursesTask

            currentUserDisplayName = resolvedDisplayName(from: user)
            courses = coursesPage.content.map(Self.mapCourseToCardItem)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = "Unexpected error"
        }
    }

    func retryTapped() async {
        await loadInitialData()
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
        let displayName = user.displayName
            return displayName
  
    }

    private static func mapCourseToCardItem(_ course: Course) -> CourseCardItem {
        CourseCardItem(
            id: course.id,
            name: course.name,
            description: course.description ?? "",
            isTeacher: course.currentUserRole == .teacher,
            teacherCount: course.teacherCount,
            studentCount: course.studentCount
        )
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
