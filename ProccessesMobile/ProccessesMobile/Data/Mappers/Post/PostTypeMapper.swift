//
//  PostTypeMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 13.03.2026.
//

import Foundation

enum PostTypeMapper {
    static func toDomain(_ dto: PostTypeDTO) -> PostType {
        switch dto {
        case .material:
            return .material
        case .task:
            return .task
        }
    }

    static func toDTO(_ domain: PostType) -> PostTypeDTO {
        switch domain {
        case .material:
            return .material
        case .task:
            return .task
        }
    }
}
