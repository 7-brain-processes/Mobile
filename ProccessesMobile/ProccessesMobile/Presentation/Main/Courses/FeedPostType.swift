//
//  FeedPostType.swift
//  ProccessesMobile
//
//  Created by dark type on 9.03.2026.
//

import Foundation

enum FeedPostType: Equatable {
    case material
    case task

    var title: String {
        switch self {
        case .material: return "Material"
        case .task: return "Task"
        }
    }
}

enum FeedAttachmentType: Equatable {
    case image
    case audio
    case file
}


struct FeedAttachmentItem: Identifiable, Equatable, Hashable {
    let id: UUID
    let type: FeedAttachmentType
    let fileName: String
    let previewURL: URL?

    var isPreviewableImage: Bool {
        type == .image
    }
}

struct FeedAuthorItem: Equatable {
    let displayName: String
}

struct FeedPostItem: Identifiable, Equatable {
    let id: UUID
    let type: FeedPostType
    let title: String
    let contentPreview: String
    let createdAt: Date
    let deadline: Date?
    let author: FeedAuthorItem
    let attachments: [FeedAttachmentItem]
    let commentsCount: Int
    let solutionsCount: Int?
    let mySolutionId: UUID?
}

struct TaskDetailItem: Equatable {
    let id: UUID
    let title: String
    let content: String
    let createdAt: Date
    let deadline: Date?
    let authorDisplayName: String
    let attachments: [FeedAttachmentItem]
    let comments: [PostCommentItem]
}
struct MaterialDetailItem: Equatable {
    let id: UUID
    let title: String
    let content: String
    let createdAt: Date
    let authorDisplayName: String
    let attachments: [FeedAttachmentItem]
    let comments: [PostCommentItem]
}

struct TaskSubmissionItem: Identifiable, Equatable {
    let id: UUID
    let studentName: String
    let submittedAt: Date?
    let status: SubmissionStatus
    let text: String
    let grade: Int?
    let teacherComments: [TeacherReviewCommentItem]
    let attachments: [FeedAttachmentItem]
    let isLate: Bool
}
extension TaskSubmissionItem {
    var displayStatusTitle: String {
        if isLate {
            return "Late submission"
        }

        switch status {
        case .draft:
            return "Draft"
        case .submitted:
            return "Turned in"
        case .rejected:
            return "Returned"
        case .accepted:
            return "Graded"
        }
    }

    var displayGradeText: String {
        if let grade {
            return "\(grade)/100"
        } else {
            return "/100"
        }
    }
}
struct PostCommentItem: Identifiable, Equatable {
    let id: UUID
    let authorName: String
    let text: String
    let createdAt: Date
}
