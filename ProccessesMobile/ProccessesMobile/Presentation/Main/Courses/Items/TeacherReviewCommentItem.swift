//
//  TeacherReviewCommentItem.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct TeacherReviewCommentItem: Identifiable, Equatable {
    let id: UUID
    let authorName: String
    let text: String
    let createdAt: Date
}
