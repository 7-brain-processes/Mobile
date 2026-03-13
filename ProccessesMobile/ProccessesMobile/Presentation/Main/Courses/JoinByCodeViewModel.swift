//
//  JoinByCodeViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import Foundation
import Combine

@MainActor
final class JoinByCodeViewModel: ObservableObject {
    private weak var navigator: CoursesNavigating?

    @Published var code: String = ""

    init(navigator: CoursesNavigating) {
        self.navigator = navigator
    }

    func cancelTapped() {
        navigator?.dismissSheet()
    }

    func joinTapped() {
        let joinedCourseId = UUID()
        navigator?.dismissSheet()
        navigator?.openCourse(id: joinedCourseId)
    }
}
