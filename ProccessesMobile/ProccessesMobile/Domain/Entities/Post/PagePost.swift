//
//  PagePost.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct PagePost: Equatable, Sendable, Codable {
    let content: [Post]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}
