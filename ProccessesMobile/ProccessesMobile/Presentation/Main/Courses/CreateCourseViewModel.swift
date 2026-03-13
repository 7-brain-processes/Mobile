//
//  CreateCourseViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation
import Combine

@MainActor
final class CreateCourseViewModel: ObservableObject {
    private weak var navigator: CoursesNavigating?

    @Published var courseName: String = ""

    init(navigator: CoursesNavigating) {
        self.navigator = navigator
    }

    func cancelTapped() {
        navigator?.dismissSheet()
    }

    func finishTapped() {
        let createdCourseId = UUID()
        navigator?.dismissSheet()
        navigator?.openCourse(id: createdCourseId)
    }
}
