//
//  GetGradeDecompositionQuery.swift
//  ProccessesMobile
//

import Foundation

struct GetGradeDecompositionQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
}
