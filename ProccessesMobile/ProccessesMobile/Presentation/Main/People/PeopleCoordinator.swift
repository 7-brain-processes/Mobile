//
//  PeopleCoordinator.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import Foundation
import Combine

@MainActor
final class PeopleCoordinator: ObservableObject {
    let courseId: UUID

    init(courseId: UUID) {
        self.courseId = courseId
    }
}
