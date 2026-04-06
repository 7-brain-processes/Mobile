//
//  CoursesNavigating.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import Foundation

@MainActor
protocol CoursesNavigating: AnyObject {
    func openCreateCourse()
    func openJoinByCode()
    func dismissSheet()
    func openCourse(id: UUID)
}
