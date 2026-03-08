//
//  GradeRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct GradeRequest: Equatable, Sendable, Codable {
    let grade: UUID
    let comment: String?
    
    init(grade: UUID, comment: String? = nil) {
        self.grade = grade
        self.comment = comment
    }
}
