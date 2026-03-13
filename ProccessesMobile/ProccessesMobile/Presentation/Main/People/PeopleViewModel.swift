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

    private let courseMembersRepository: CourseMembersRepository
    private let createInviteUseCase: CreateInviteUseCase
    private let removeMemberUseCase: RemoveMemberUseCase

    @Published var teachers: [CoursePersonItem] = []
    @Published var students: [CoursePersonItem] = []

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    @Published var isInviteSheetPresented = false
    @Published var inviteTargetRole: CourseRole = .student
    @Published var inviteMaxUses: Int = 1
    @Published var inviteDurationDays: Int = 7
    @Published var generatedInviteCode: String?

    @Published var isGeneratingInvite: Bool = false
    @Published var isRemovingMember: Bool = false

    init(
        courseId: UUID,
        role: CourseRole,
        courseMembersRepository: CourseMembersRepository,
        createInviteUseCase: CreateInviteUseCase,
        removeMemberUseCase: RemoveMemberUseCase
    ) {
        self.courseId = courseId
        self.role = role
        self.courseMembersRepository = courseMembersRepository
        self.createInviteUseCase = createInviteUseCase
        self.removeMemberUseCase = removeMemberUseCase
    }

    var canManagePeople: Bool {
        role == .teacher
    }

    func onAppear() {
        guard teachers.isEmpty, students.isEmpty, !isLoading else { return }
        loadPeople()
    }

    func refresh() {
        loadPeople()
    }

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
        guard canManagePeople else { return }

        Task {
            isGeneratingInvite = true
            errorMessage = nil

            defer { isGeneratingInvite = false }

            do {
                let expiresAt = Calendar.current.date(
                    byAdding: .day,
                    value: inviteDurationDays,
                    to: Date()
                ) ?? Date()

                let invite = try await createInviteUseCase.execute(
                    CreateInviteCommand(
                        courseId: courseId,
                        role: mapInviteRole(inviteTargetRole),
                        expiresAt: expiresAt,
                        maxUses: inviteMaxUses
                    )
                )

                generatedInviteCode = invite.code
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func kick(_ person: CoursePersonItem) {
        guard canManagePeople else { return }

        Task {
            isRemovingMember = true
            errorMessage = nil

            defer { isRemovingMember = false }

            do {
                try await removeMemberUseCase.execute(
                    RemoveMemberCommand(
                        courseId: courseId,
                        userId: person.id
                    )
                )

                switch person.role {
                case .teacher:
                    teachers.removeAll { $0.id == person.id }
                case .student:
                    students.removeAll { $0.id == person.id }
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func loadPeople() {
        Task {
            isLoading = true
            errorMessage = nil

            defer { isLoading = false }

            do {
                async let teachersPage = courseMembersRepository.listMembers(
                    ListMembersQuery(
                        courseId: courseId,
                        page: 0,
                        size: 100,
                        role: .teacher
                    )
                )

                async let studentsPage = courseMembersRepository.listMembers(
                    ListMembersQuery(
                        courseId: courseId,
                        page: 0,
                        size: 100,
                        role: .student
                    )
                )

                let (teachersResult, studentsResult) = try await (teachersPage, studentsPage)

                teachers = teachersResult.content.map {
                    CoursePersonItem(
                        id: $0.id,
                        name: $0.user.displayName,
                        role: .teacher
                    )
                }

                students = studentsResult.content.map {
                    CoursePersonItem(
                        id: $0.id,
                        name: $0.user.displayName,
                        role: .student
                    )
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func mapInviteRole(_ role: CourseRole) -> CourseRole {
        switch role {
        case .teacher:
            return .teacher
        case .student:
            return .student
        }
    }
}
