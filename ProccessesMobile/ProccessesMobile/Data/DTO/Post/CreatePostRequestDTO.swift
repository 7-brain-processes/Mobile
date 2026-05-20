//
//  CreatePostRequest.swift
//  ProccessesMobile
//
//  Created Tark Wight on 07.03.2026.
//

struct CreatePostRequestDTO: Equatable, Sendable, Codable {
    let title: String
    let content: String?
    let type: PostTypeDTO
    let teamFormationMode: TeamFormationModeDTO?
    let teamRequirementTemplateId: String?
    let deadline: String?
}
