//
//  PostType.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum PostTypeDTO: String, Codable, Equatable, Sendable {
    case material = "MATERIAL"
    case task = "TASK"
}

extension PostTypeDTO {
    func toDomain() -> PostType {
        switch self {
        case .material: return .material
        case .task: return .task
        }
    }
}
