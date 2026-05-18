//
//  CreateTeamRequirementTemplateRequestDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//

import Foundation

struct CreateTeamRequirementTemplateRequestDTO: Equatable, Sendable, Codable {
    let name: String
    let description: String?
    let minTeamSize: Int?
    let maxTeamSize: Int?
    let requiredCategoryId: String?
    let requireAudio: Bool
    let requireVideo: Bool
}
