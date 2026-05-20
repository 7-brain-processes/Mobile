//
//  CourseCategoryDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

struct CourseCategoryDTO: Codable, Equatable, Identifiable, Sendable {
    let id: String
    let title: String
    let description: String
    let active: Bool
    let createdAt: String
}
