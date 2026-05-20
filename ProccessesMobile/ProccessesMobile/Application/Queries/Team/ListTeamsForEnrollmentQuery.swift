//
//  ListTeamsForEnrollmentQuery.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct ListTeamsForEnrollmentQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
}
