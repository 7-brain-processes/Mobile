//
//  CreatePostTeamRequestDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//

import Foundation

struct CreatePostTeamRequestDTO: Equatable, Sendable, Codable {
    let name: String
    let maxSize: Int?
    let selfEnrollmentEnabled: Bool
}
