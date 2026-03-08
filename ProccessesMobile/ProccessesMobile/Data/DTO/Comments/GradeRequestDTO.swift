//
//  GradeRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

struct GradeRequestDTO: Equatable, Sendable, Codable {
    let grade: Int
    let comment: String?
    
    init(grade: Int, comment: String? = nil) {
        self.grade = grade
        self.comment = comment
    }
}
