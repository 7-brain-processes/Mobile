//
//  CreateSolutionRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct CreateSolutionRequest: Equatable, Sendable, Codable {
    let text: String?
    
    init(text: String? = nil) {
        self.text = text
    }
}
