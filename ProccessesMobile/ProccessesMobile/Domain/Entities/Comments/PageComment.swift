//
//  PageComment.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct PageComment: Equatable, Sendable, Codable {
    public let content: [Comment]
    public let page: Int
    public let size: Int
    public let totalElements: Int
    public let totalPages: Int
}
