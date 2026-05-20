//
//  CourseTeam.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

struct CourseTeam: Identifiable, Equatable, Sendable {
    let id: UUID
    let postId: UUID?
    let name: String
    let membersCount: Int
    let maxSize: Int?
    let selfEnrollmentEnabled: Bool
    let categories: [CourseCategory]
    let teamGrade: Int?
    let createdAt: Date?
}

extension CourseTeam {
    func toAvailabilityItem() -> CourseTeamAvailability {
        CourseTeamAvailability(
            id: id,
            name: name,
            teamGrade: teamGrade, currentMembers: membersCount,
            maxSize: maxSize,
            selfEnrollmentEnabled: selfEnrollmentEnabled,
            isFull: maxSize.map { membersCount >= $0 } ?? false,
            isStudentMember: false,
            categories: categories,
            createdAt: createdAt ?? Date()
        )
    }
}
