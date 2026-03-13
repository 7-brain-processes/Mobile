//
//  MainFlowView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI

struct MainFlowView<Factory: AppViewFactory>: View {
    @ObservedObject var coordinator: CoursesCoordinator
    let factory: Factory

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            factory.makeCoursesView(coordinator: coordinator)
                .navigationDestination(for: MainRoute.self) { route in
                    switch route {
                    case let .course(courseId):
                        factory.makeCourseFlowView(
                            coursesCoordinator: coordinator,
                            courseId: courseId
                        )

                    case let .taskDetails(courseId, postId):
                        factory.makeTaskDetailView(courseId: courseId, postId: postId)

                    case let .materialDetails(courseId, postId):
                        factory.makeMaterialDetailView(courseId: courseId, postId: postId)

                    case let .createPost(courseId, postType):
                        factory.makeCreatePostView(courseId: courseId, postType: postType)
                    }
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    switch sheet {
                    case .createCourse:
                        factory.makeCreateCourseView(coordinator: coordinator)
                    case .joinByCode:
                        factory.makeJoinByCodeView(coordinator: coordinator)
                    }
                }
        }
    }
}
