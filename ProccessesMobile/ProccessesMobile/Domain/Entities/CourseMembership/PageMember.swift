//
//  PageMember.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct PageMember: Equatable, Sendable, Codable {
    let content: [Member]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}
