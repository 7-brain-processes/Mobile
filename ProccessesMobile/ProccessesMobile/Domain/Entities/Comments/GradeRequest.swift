//
//  GradeRequest.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public struct GradeRequest: Equatable, Sendable, Codable {
    public let grade: Int
    public let comment: String?
    
    public init(grade: Int, comment: String? = nil) {
        self.grade = grade
        self.comment = comment
    }
}
