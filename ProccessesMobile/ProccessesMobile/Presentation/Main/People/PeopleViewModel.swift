//
//  PeopleViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import Foundation
import Combine

@MainActor
final class PeopleViewModel: ObservableObject {
    let courseId: UUID
    let role: CourseRole

    @Published var teachers: [CoursePersonItem]
    @Published var students: [CoursePersonItem]
    
    @Published var isInviteSheetPresented = false
    @Published var inviteTargetRole: CourseRole = .student
    @Published var inviteMaxUses: Int = 1
    @Published var inviteDurationDays: Int = 7
    @Published var generatedInviteCode: String?

    func addTeacherTapped() {
        inviteTargetRole = .teacher
        generatedInviteCode = nil
        isInviteSheetPresented = true
    }

    func addStudentTapped() {
        inviteTargetRole = .student
        generatedInviteCode = nil
        isInviteSheetPresented = true
    }

    func generateInviteCode() {
        generatedInviteCode = String(UUID().uuidString.prefix(8)).uppercased()
    }

    init(
        courseId: UUID,
        role: CourseRole,
        teachers: [CoursePersonItem] = [
            CoursePersonItem(id: UUID(), name: "Professor Adams", role: .teacher)
        ],
        students: [CoursePersonItem] = [
            CoursePersonItem(id: UUID(), name: "Alice Brown", role: .student),
            CoursePersonItem(id: UUID(), name: "Bob Green", role: .student)
        ]
    ) {
        self.courseId = courseId
        self.role = role
        self.teachers = teachers
        self.students = students
    }

    var canManagePeople: Bool {
        role == .teacher
    }


    func kick(_ person: CoursePersonItem) {
        switch person.role {
        case .teacher:
            teachers.removeAll { $0.id == person.id }
        case .student:
            students.removeAll { $0.id == person.id }
        }
    }
}
