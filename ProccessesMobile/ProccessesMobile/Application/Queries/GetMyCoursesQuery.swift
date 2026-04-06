//
//  GetMyCoursesQuery.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct GetMyCoursesQuery: Equatable, Sendable {
    let page: Int
    let size: Int
    let role: CourseRole?
}
