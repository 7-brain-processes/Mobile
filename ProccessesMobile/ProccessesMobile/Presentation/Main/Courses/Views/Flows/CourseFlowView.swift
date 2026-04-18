//
//  CourseFlowView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI

struct CourseFlowView: View {
    @ObservedObject var coordinator: CourseCoordinator
    let coursesCoordinator: CoursesCoordinator
    let factory: any AppViewFactory
    let role: CourseRole

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            factory.makeFeedView(
                courseId: coordinator.courseId,
                role: role,
                navigator: coursesCoordinator
            )
            .tabItem {
                Label("Feed", systemImage: "list.bullet.rectangle")
            }
            .tag(CourseTab.feed)

            factory.makeTasksView(
                courseId: coordinator.courseId,
                role: role,
                navigator: coursesCoordinator
            )
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            .tag(CourseTab.tasks)

            factory.makePeopleView(
                courseId: coordinator.courseId,
                role: role
            )
            .tabItem {
                Label("People", systemImage: "person.3")
            }
            .tag(CourseTab.people)

            factory.makeCourseCategoriesView(
                courseId: coordinator.courseId,
            )
            .tabItem {
                Label("Categories", systemImage: "tag")
            }
            .tag(CourseTab.categories)
        }
        .navigationTitle("Course")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Course")
                    .accessibilityIdentifier(AccessibilityID.Course.title)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Text(role == .teacher ? "Teacher" : "Student")
                    .accessibilityIdentifier(
                        role == .teacher
                        ? AccessibilityID.Course.teacherBadge
                        : AccessibilityID.Course.studentBadge
                    )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
