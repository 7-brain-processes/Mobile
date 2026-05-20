//
//  CourseTeamMemberMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum CourseTeamMemberMapper {
    static func toDomain(_ dto: CourseTeamMemberDTO) throws -> CourseTeamMember {
        CourseTeamMember(
            user: try dto.user.map(UserMapper.toDomain)!,
            category: try dto.category.map(CourseCategoryMapper.toDomain)
        )
    }
}
