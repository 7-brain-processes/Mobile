//
//  CoursePersonItem.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct CoursePersonItem: Identifiable, Equatable {
    let id: UUID
    let name: String
    let role: CourseRole
}
