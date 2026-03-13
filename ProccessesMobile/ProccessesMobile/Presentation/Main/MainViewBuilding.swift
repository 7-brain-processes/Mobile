//
//  MainViewBuilding.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import SwiftUI

@MainActor
protocol MainViewBuilding {
    func makeCoursesView(coordinator: CoursesCoordinator) -> AnyView
    func makeCourseView(courseId: UUID) -> AnyView
}