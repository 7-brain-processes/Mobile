//
//  CreateTeamRequirementTemplateCommand.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

struct CreateTeamRequirementTemplateCommand: Equatable, Sendable {
    let courseId: UUID
    let name: String
    let description: String?
    let minTeamSize: Int?
    let maxTeamSize: Int?
    let requiredCategoryId: UUID?
    let requireAudio: Bool
    let requireVideo: Bool
}