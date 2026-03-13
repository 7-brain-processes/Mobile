//
//  GetCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol GetCourseUseCase: Sendable {
    func execute(_ query: CourseQuery) async throws -> Course
}

