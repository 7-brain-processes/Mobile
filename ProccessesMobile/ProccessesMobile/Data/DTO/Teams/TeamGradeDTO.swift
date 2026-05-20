//
//  TeamGradeDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

struct TeamGradeDTO: Equatable, Sendable, Codable {
    let id: String?
    let postId: String
    let teamId: String
    let grade: Int?
    let comment: String?
    let distributionMode: String?
    let updatedAt: String?
}
