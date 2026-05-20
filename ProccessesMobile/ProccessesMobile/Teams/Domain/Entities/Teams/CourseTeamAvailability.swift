//
//  CourseTeamAvailability.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct CourseTeamAvailability: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let teamGrade: Int?
    let currentMembers: Int
    let maxSize: Int?
    let selfEnrollmentEnabled: Bool
    let isFull: Bool
    let isStudentMember: Bool
    let categories: [CourseCategory]
    let createdAt: Date
}

extension CourseTeamAvailability {
    func withTeamGrade(_ teamGrade: Int?) -> CourseTeamAvailability {
        CourseTeamAvailability(
            id: id,
            name: name,
            teamGrade: teamGrade,
            currentMembers: currentMembers,
            maxSize: maxSize,
            selfEnrollmentEnabled: selfEnrollmentEnabled,
            isFull: isFull,
            isStudentMember: isStudentMember,
            categories: categories,
            createdAt: createdAt
        )
    }
}
