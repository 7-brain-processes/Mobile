//
//  PageMember.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct PageMember: Equatable, Sendable, Codable {
    public let content: [Member]
    public let page: Int
    public let size: Int
    public let totalElements: Int
    public let totalPages: Int
}
