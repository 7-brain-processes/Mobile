//
//  TeamEnrollmentStatusDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct TeamEnrollmentStatusDTO: Equatable, Sendable, Codable {
    let teamId: String
    let teamName: String
    let currentMembers: Int
    let maxSize: Int?
}