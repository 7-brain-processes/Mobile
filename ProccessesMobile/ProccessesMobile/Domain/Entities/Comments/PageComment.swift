//
//  PageComment.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct PageComment: Equatable, Sendable, Codable {
    let content: [Comment]
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}
