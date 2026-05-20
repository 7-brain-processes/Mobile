//
//  TeamRequirementTemplateDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

struct TeamRequirementTemplateDTO: Equatable, Sendable, Codable {
    let id: String
    let name: String
    let description: String?
    let minTeamSize: Int?
    let maxTeamSize: Int?
    let requiredCategory: CourseCategoryDTO?
    let requireAudio: Bool
    let requireVideo: Bool
    let active: Bool
    let createdAt: String
    let archivedAt: String?
}