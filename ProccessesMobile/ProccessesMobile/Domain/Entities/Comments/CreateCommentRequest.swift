//
//  CreateCommentRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct CreateCommentRequest: Equatable, Sendable, Codable {
    let text: String
    init(text: String) { self.text = text }
}