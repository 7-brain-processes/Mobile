//
//  PageSolution.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct PageSolution: Equatable, Sendable, Codable {
    let content: [Solution]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}