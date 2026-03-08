//
//  GradeRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


struct GradeRequest: Equatable, Sendable, Codable {
    let grade: Int
    let comment: String?
    
    init(grade: Int, comment: String? = nil) {
        self.grade = grade
        self.comment = comment
    }
}
