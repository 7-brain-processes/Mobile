//
//  Member.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct Member: Equatable, Sendable {
    let user: User?
    let role: CourseRole
    let joinedAt: Date
}
