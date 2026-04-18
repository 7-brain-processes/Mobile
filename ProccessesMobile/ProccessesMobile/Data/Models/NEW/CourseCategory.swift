//
//  CourseCategory.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

struct CourseCategory: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
    let description: String
    let isActive: Bool
    let createdAt: Date
}