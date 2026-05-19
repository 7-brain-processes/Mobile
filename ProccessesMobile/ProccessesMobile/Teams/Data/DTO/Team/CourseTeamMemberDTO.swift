//
//  CourseTeamMemberDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct CourseTeamMemberDTO: Equatable, Sendable, Codable {
    let user: UserDTO?
    let category: CourseCategoryDTO?
}
