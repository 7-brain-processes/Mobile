//
//  TeamFormationModeDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


enum TeamFormationModeDTO: String, Codable, Equatable, Sendable {
    case free = "FREE"
    case draft = "DRAFT"
    case randomShuffle = "RANDOM_SHUFFLE"
    case captainSelection = "CAPTAIN_SELECTION"
}