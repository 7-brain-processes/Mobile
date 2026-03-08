//
//  PageCourse.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct PageCourse: Equatable, Sendable, Codable {
    let content: [Course]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}
