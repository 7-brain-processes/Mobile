//
//  TeamRequirementTemplate.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

struct TeamRequirementTemplate: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let description: String?
    let minTeamSize: Int?
    let maxTeamSize: Int?
    let requiredCategory: CourseCategory?
    let requireAudio: Bool
    let requireVideo: Bool
    let active: Bool
    let createdAt: Date
    let archivedAt: Date?
}