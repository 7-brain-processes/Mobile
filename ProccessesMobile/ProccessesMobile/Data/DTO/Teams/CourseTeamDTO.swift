//
//  CourseTeamDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

struct CourseTeamDTO: Equatable, Sendable, Codable {
    let id: String
    let postId: String?
    let name: String
    let createdAt: String?
    let membersCount: Int
    let maxSize: Int?
    let selfEnrollmentEnabled: Bool
    let categories: [CourseCategoryDTO]?
    let teamGrade: Int?
    let full: Bool?
}