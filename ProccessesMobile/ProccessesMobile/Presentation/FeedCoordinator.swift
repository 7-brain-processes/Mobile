//
//  FeedCoordinator.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//
//
//import Combine
//import Foundation
//
//enum FeedRoute: Hashable {
//    case postDetails(courseId: UUID, postId: UUID)
//    case postEditorCreate(courseId: UUID)
//    case postEditorEdit(courseId: UUID, postId: UUID)
//    case postMaterials(courseId: UUID, postId: UUID)
//    case postComments(courseId: UUID, postId: UUID)
//
//    case mySolution(courseId: UUID, postId: UUID, solutionId: UUID)
//    case solutionEditorCreate(courseId: UUID, postId: UUID)
//    case solutionEditorEdit(courseId: UUID, postId: UUID, solutionId: UUID)
//
//    case solutionsList(courseId: UUID, postId: UUID)
//    case solutionDetails(courseId: UUID, postId: UUID, solutionId: UUID)
//    case solutionFiles(courseId: UUID, postId: UUID, solutionId: UUID)
//    case solutionComments(courseId: UUID, postId: UUID, solutionId: UUID)
//}
//
//enum FeedSheet: Identifiable, Equatable {
//    case grade(courseId: UUID, postId: UUID, solutionId: UUID)
//
//    var id: String {
//        switch self {
//        case let .grade(courseId, postId, solutionId):
//            return "grade-\(courseId)-\(postId)-\(solutionId)"
//        }
//    }
//}
//
//@MainActor
//final class FeedCoordinator: ObservableObject, CoordinatorProtocol {
//    let courseId: UUID
//
//    @Published var path: [FeedRoute] = []
//    @Published var sheet: FeedSheet?
//
//    init(courseId: UUID) {
//        self.courseId = courseId
//    }
//
//    func start() {
//        path = []
//        sheet = nil
//    }
//
//    func openPostDetails(postId: UUID) {
//        path.append(.postDetails(courseId: courseId, postId: postId))
//    }
//
//    func openCreatePost(as role: CourseRole) {
//        guard role == .teacher else { return }
//        path.append(.postEditorCreate(courseId: courseId))
//    }
//
//    func openEditPost(postId: UUID, as role: CourseRole) {
//        guard role == .teacher else { return }
//        path.append(.postEditorEdit(courseId: courseId, postId: postId))
//    }
//
//    func openMaterials(postId: UUID) {
//        path.append(.postMaterials(courseId: courseId, postId: postId))
//    }
//
//    func openComments(postId: UUID) {
//        path.append(.postComments(courseId: courseId, postId: postId))
//    }
//
//    func openStudentSolution(for post: Post, as role: CourseRole) {
//        guard role == .student else { return }
//        guard post.type == .task else { return }
//
//        if let solutionId = post.mySolutionId {
//            path.append(.mySolution(courseId: courseId, postId: post.id, solutionId: solutionId))
//        } else {
//            path.append(.solutionEditorCreate(courseId: courseId, postId: post.id))
//        }
//    }
//
//    func openEditOwnSolution(postId: UUID, solutionId: UUID, as role: CourseRole) {
//        guard role == .student else { return }
//        path.append(.solutionEditorEdit(courseId: courseId, postId: postId, solutionId: solutionId))
//    }
//
//    func openSolutionsList(postId: UUID, as role: CourseRole) {
//        guard role == .teacher else { return }
//        path.append(.solutionsList(courseId: courseId, postId: postId))
//    }
//
//    func openSolutionDetails(postId: UUID, solutionId: UUID, as role: CourseRole) {
//        guard role == .teacher else { return }
//        path.append(.solutionDetails(courseId: courseId, postId: postId, solutionId: solutionId))
//    }
//
//    func openSolutionFiles(postId: UUID, solutionId: UUID) {
//        path.append(.solutionFiles(courseId: courseId, postId: postId, solutionId: solutionId))
//    }
//
//    func openSolutionComments(postId: UUID, solutionId: UUID) {
//        path.append(.solutionComments(courseId: courseId, postId: postId, solutionId: solutionId))
//    }
//
//    func openGrade(postId: UUID, solutionId: UUID, as role: CourseRole) {
//        guard role == .teacher else { return }
//        sheet = .grade(courseId: courseId, postId: postId, solutionId: solutionId)
//    }
//
//    func dismissSheet() {
//        sheet = nil
//    }
//}
