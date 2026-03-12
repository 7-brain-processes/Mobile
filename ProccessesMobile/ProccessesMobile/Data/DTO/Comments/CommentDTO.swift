//
//  Comment.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Foundation

struct CommentDTO: Equatable, Sendable, Codable {
    let id: String
    let text: String
    let author: UserDTO?
    let createdAt: String
    let updatedAt: String
}
