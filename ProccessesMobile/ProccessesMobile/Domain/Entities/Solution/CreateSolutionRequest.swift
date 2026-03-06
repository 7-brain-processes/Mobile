//
//  CreateSolutionRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct CreateSolutionRequest: Equatable, Sendable, Codable {
    public let text: String?
    
    public init(text: String? = nil) {
        self.text = text
    }
}
