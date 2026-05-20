//
//  GradingConfigDTO.swift
//  ProccessesMobile
//

import Foundation

struct UpsertGradingConfigRequestDTO: Equatable, Sendable, Codable {
    let maxGrade: Double
    let criteria: [CriterionConfigDTO]
    let modifiers: [ModifierConfigDTO]
    let resultsVisible: Bool
}

struct GradingConfigResponseDTO: Equatable, Sendable, Codable {
    let id: String?
    let maxGrade: Double
    let criteria: [CriterionConfigDTO]
    let modifiers: [ModifierConfigDTO]
    let resultsVisible: Bool
    let createdAt: String?
    let updatedAt: String?
}

struct CriterionConfigDTO: Equatable, Sendable, Codable {
    let id: String?
    let title: String
    let type: String
    let maxPoints: Double
    let weight: Double
    let commentEnabled: Bool?
}

struct ModifierConfigDTO: Equatable, Sendable, Codable {
    let id: String?
    let title: String?
    let type: String
    let enabled: Bool?
    let weight: Double?
}
