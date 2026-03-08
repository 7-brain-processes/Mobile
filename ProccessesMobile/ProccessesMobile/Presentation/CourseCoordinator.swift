////
////  CourseCoordinator.swift
////  ProccessesMobile
////
////  Created by Tark Wight on 07.03.2026.
////
//
//import Combine
//import Foundation
//
//enum CourseTab: Hashable {
//    case feed
//    case members
//    case invites
//    case info
//}
//
//@MainActor
//final class CourseCoordinator: ObservableObject, CoordinatorProtocol {
//    let courseId: UUID
//    @Published var selectedTab: CourseTab
//
//    let feedCoordinator: FeedCoordinator
//    let membersCoordinator: MembersCoordinator
//    let invitesCoordinator: InvitesCoordinator
//    let infoCoordinator: InfoCoordinator
//
//    init(courseId: UUID) {
//        self.courseId = courseId
//        self.selectedTab = .feed
//        self.feedCoordinator = FeedCoordinator(courseId: courseId)
//        self.membersCoordinator = MembersCoordinator(courseId: courseId)
//        self.invitesCoordinator = InvitesCoordinator(courseId: courseId)
//        self.infoCoordinator = InfoCoordinator(courseId: courseId)
//    }
//
//    func start() {
//        selectedTab = .feed
//        feedCoordinator.start()
//        membersCoordinator.start()
//        invitesCoordinator.start()
//        infoCoordinator.start()
//    }
//
//    func selectTab(_ tab: CourseTab) {
//        selectedTab = tab
//    }
//}
