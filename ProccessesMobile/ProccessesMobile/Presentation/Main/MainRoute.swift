//
//  MainRoute.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//

import Combine
import Foundation

enum MainRoute: Hashable {
    case course(courseId: UUID)

    case taskDetails(courseId: UUID, postId: UUID)
    case materialDetails(courseId: UUID, postId: UUID)
    case createPost(UUID, FeedPostType)

    case courseCategories(courseId: UUID)
}

enum MainSheet: Identifiable, Equatable {
    case createCourse
    case joinByCode

    var id: String {
        switch self {
        case .createCourse: return "createCourse"
        case .joinByCode: return "joinByCode"
        }
    }
}
