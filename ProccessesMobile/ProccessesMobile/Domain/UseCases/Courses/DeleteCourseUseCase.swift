//
//  DeleteCourseUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

protocol DeleteCourseUseCase: Sendable {
    func execute(_ query: DeleteCourseQuery) async throws
}
