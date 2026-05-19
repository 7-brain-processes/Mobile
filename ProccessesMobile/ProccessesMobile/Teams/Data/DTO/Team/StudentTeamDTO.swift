//
//  StudentTeamDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct StudentTeamDTO: Equatable, Sendable, Codable {
    let teamId: String
    let teamName: String
    let membersCount: Int
    let maxSize: Int?
    let members: [CourseTeamMemberDTO]?
    let joinedAt: String?
}