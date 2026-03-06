//
//  CreateCommentRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct CreateCommentRequest: Equatable, Sendable, Codable {
    public let text: String
    public init(text: String) { self.text = text }
}