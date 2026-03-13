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
    private weak var navigator: CoursesNavigating?
    private weak var appRouter: AppFlowRouting?

    @Published var courses: [CourseCardItem]

    let currentUserDisplayName: String

    init(
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
        self.navigator = navigator
        self.appRouter = appRouter
        self.currentUserDisplayName = currentUserDisplayName
        self.courses = courses
    }

    var currentUserInitial: String {
        String(currentUserDisplayName.prefix(1)).uppercased()
    }

    var teachingCourses: [CourseCardItem] {
        courses.filter(\.isTeacher)
    }

    var attendingCourses: [CourseCardItem] {
        courses.filter { !$0.isTeacher }
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
}
