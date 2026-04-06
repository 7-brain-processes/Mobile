//
//  Comment.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Comment: Equatable, Sendable {
    let id: UUID
    let text: String
    let author: User?
    let createdAt: Date
    let updatedAt: Date
}
