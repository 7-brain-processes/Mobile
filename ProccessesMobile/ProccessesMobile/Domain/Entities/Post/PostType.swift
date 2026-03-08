//
//  PostType.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum PostType: String, Codable, Equatable, Sendable {
    case material = "MATERIAL"
    case task = "TASK"
}

extension PostType {
    func toDTO() -> PostTypeDTO {
        switch self {
        case .material: return .material
        case .task: return .task
        }
    }
}
