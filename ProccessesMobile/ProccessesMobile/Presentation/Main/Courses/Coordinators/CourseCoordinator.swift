//
//  CourseCoordinator.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

import Combine
import Foundation

@MainActor
final class CourseCoordinator: ObservableObject {
    let courseId: UUID

    @Published var selectedTab: CourseTab = .feed

    let tasksCoordinator: TasksCoordinator
    let peopleCoordinator: PeopleCoordinator

    init(
        courseId: UUID,
        tasksCoordinator: TasksCoordinator,
        peopleCoordinator: PeopleCoordinator
    ) {
        self.courseId = courseId
        self.tasksCoordinator = tasksCoordinator
        self.peopleCoordinator = peopleCoordinator
    }

    func start() {
        selectedTab = .feed
    }
}

