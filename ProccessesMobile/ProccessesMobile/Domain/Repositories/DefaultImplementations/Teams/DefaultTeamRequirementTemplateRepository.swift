//
//  DefaultTeamRequirementTemplateRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

struct DefaultTeamRequirementTemplateRepository: TeamRequirementTemplateRepository, Sendable {
    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listTemplates(courseId: UUID) async throws -> [TeamRequirementTemplate] {
        let endpoint = TeamRequirementTemplateEndpoint.list(
            courseId: courseId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode([TeamRequirementTemplateDTO].self, from: data)

        return try dto.map(TeamRequirementTemplateMapper.toDomain)
    }

    func createTemplate(
        _ command: CreateTeamRequirementTemplateCommand
    ) async throws -> TeamRequirementTemplate {
        let endpoint = TeamRequirementTemplateEndpoint.create(
            courseId: command.courseId.uuidString,
            request: CreateTeamRequirementTemplateMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(TeamRequirementTemplateDTO.self, from: data)

        return try TeamRequirementTemplateMapper.toDomain(dto)
    }
}