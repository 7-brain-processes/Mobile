//
//  FeedNavigating.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//

import Foundation

@MainActor
protocol FeedNavigating: AnyObject {
    func openTaskDetail(courseId: UUID, postId: UUID, role: CourseRole)
    func openMaterialDetail(courseId: UUID, postId: UUID)
}
