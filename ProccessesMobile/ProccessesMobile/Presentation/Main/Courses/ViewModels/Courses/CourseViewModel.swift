//
//  CourseViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Combine
import Foundation

enum CourseUserRole {
    case teacher
    case student
}

@MainActor
final class CourseViewModel: ObservableObject {
    let courseId: UUID

    @Published var role: CourseUserRole

    init(
        courseId: UUID,
        role: CourseUserRole = .student
    ) {
        self.courseId = courseId
        self.role = role
    }

    var canManageCourse: Bool {
        role == .teacher
    }

    var canCreateInvite: Bool {
        role == .teacher
    }
}
