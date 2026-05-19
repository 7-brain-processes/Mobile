//
//  CourseTeamAvailabilityDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct CourseTeamAvailabilityDTO: Equatable, Sendable, Codable {
    let id: String
    let name: String
    let currentMembers: Int
    let maxSize: Int?
    let selfEnrollmentEnabled: Bool
    let isFull: Bool
    let isStudentMember: Bool
    let categories: [CourseCategoryDTO]?
    let createdAt: String?
}