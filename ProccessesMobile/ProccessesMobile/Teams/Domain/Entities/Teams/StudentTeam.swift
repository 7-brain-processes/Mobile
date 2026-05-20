//
//  StudentTeam.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct StudentTeam: Equatable, Sendable {
    let teamId: UUID
    let teamName: String
    let teamGrade: Int?
    let membersCount: Int
    let maxSize: Int?
    let members: [CourseTeamMember]
    let joinedAt: Date
}
