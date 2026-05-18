//
//  TaskDetailViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import Combine
import Foundation
import UniformTypeIdentifiers

@MainActor
final class TaskDetailViewModel: ObservableObject {
    enum TeacherTab: String, CaseIterable, Identifiable {
        case task = "Task"
        case submissions = "Submissions"

        var id: String { rawValue }
    }

    let role: CourseRole

    private let courseId: UUID
    private let postId: UUID
    private let getPostUseCase: GetPostUseCase
    private let listPostMaterialsUseCase: ListPostMaterialsUseCase
    private let uploadPostMaterialUseCase: UploadPostMaterialUseCase

    private let listPostCommentsUseCase: ListPostCommentsUseCase
    private let createPostCommentUseCase: CreatePostCommentUseCase

    @Published var item: TaskDetailItem?
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var draftComment: String = ""

    @Published var studentAttachments: [FeedAttachmentItem] = []
    @Published var studentSubmissionText: String = ""
    @Published var studentSubmissionStatus: SubmissionStatus = .draft
    @Published var studentTeacherComments: [TeacherReviewCommentItem] = []

    @Published var submissions: [TaskSubmissionItem] = []
    @Published var selectedTeacherTab: TeacherTab = .task
    @Published var isStudentWorkSheetPresented = false
    @Published var selectedSubmissionForSheet: TaskSubmissionItem?
    @Published var previewAttachment: FeedAttachmentItem?
    @Published private(set) var isPostingComment = false

    init(
        courseId: UUID,
        postId: UUID,
        role: CourseRole,
        getPostUseCase: GetPostUseCase,
        listPostMaterialsUseCase: ListPostMaterialsUseCase,
        uploadPostMaterialUseCase: UploadPostMaterialUseCase,
        listPostCommentsUseCase: ListPostCommentsUseCase,
        createPostCommentUseCase: CreatePostCommentUseCase
    ) {
        self.courseId = courseId
        self.postId = postId
        self.role = role
        self.getPostUseCase = getPostUseCase
        self.listPostMaterialsUseCase = listPostMaterialsUseCase
        self.uploadPostMaterialUseCase = uploadPostMaterialUseCase
        self.listPostCommentsUseCase = listPostCommentsUseCase
        self.createPostCommentUseCase = createPostCommentUseCase
    }

    var isTeacher: Bool { role == .teacher }
    var isStudent: Bool { role == .student }

    var canSubmitStudentWork: Bool {
        isStudent &&
        (!studentSubmissionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !studentAttachments.isEmpty) &&
        studentSubmissionStatus != .submitted
    }

    var canUnsubmitStudentWork: Bool {
        isStudent && (studentSubmissionStatus == .submitted || studentSubmissionStatus == .rejected)
    }

    func onAppear() {
        guard item == nil, !isLoading else { return }
        load()
    }

    func load() {
        Task {
            await reload()
        }
    }

    private func reload() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            async let postTask = getPostUseCase.execute(
                courseId: courseId,
                postId: postId
            )

            async let materialsTask = listPostMaterialsUseCase.execute(
                ListPostMaterialsQuery(
                    courseId: courseId,
                    postId: postId
                )
            )

            async let commentsTask = listPostCommentsUseCase.execute(
                ListPostCommentsQuery(
                    courseId: courseId,
                    postId: postId,
                    page: 0,
                    size: 50
                )
            )

            let post = try await postTask
            let materials = try await materialsTask
            let commentsPage = try await commentsTask

            item = Self.mapPostToTaskDetailItem(
                post,
                materials: materials,
                comments: commentsPage.content
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func attachMockImage() {
        studentAttachments.append(
            FeedAttachmentItem(
                id: UUID(),
                type: .image,
                fileName: "submission-\(studentAttachments.count + 1).jpg",
                previewURL: nil
            )
        )
    }

    func submitStudentWork() {
        guard canSubmitStudentWork else { return }
        studentSubmissionStatus = .submitted
    }

    func unsubmitStudentWork() {
        guard canUnsubmitStudentWork else { return }
        studentSubmissionStatus = .draft
    }

    func removeGrade(for submissionId: UUID) {
        guard let index = submissions.firstIndex(where: { $0.id == submissionId }) else { return }

        submissions[index] = TaskSubmissionItem(
            id: submissions[index].id,
            studentName: submissions[index].studentName,
            submittedAt: submissions[index].submittedAt,
            status: submissions[index].status,
            text: submissions[index].text,
            grade: nil,
            teacherComments: submissions[index].teacherComments,
            attachments: submissions[index].attachments,
            isLate: submissions[index].isLate
        )
        refreshSelectedSubmission(submissionId: submissionId)
    }

    func addPostComment(as authorName: String = "You") async {
        guard !isPostingComment else { return }

        let trimmed = draftComment.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        isPostingComment = true
        errorMessage = nil

        defer {
            isPostingComment = false
        }

        do {
            _ = try await createPostCommentUseCase.execute(
                CreatePostCommentCommand(
                    courseId: courseId,
                    postId: postId,
                    text: trimmed
                )
            )

            draftComment = ""

            await reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func normalizedGradeInput(_ value: String) -> String {
        String(value.filter(\.isNumber).prefix(3))
    }

    func applyGrade(for submissionId: UUID, from input: String) {
        let filtered = normalizedGradeInput(input)
        guard let parsed = Int(filtered) else { return }
        let clamped = min(max(parsed, 0), 100)

        guard let index = submissions.firstIndex(where: { $0.id == submissionId }) else { return }

        submissions[index] = TaskSubmissionItem(
            id: submissions[index].id,
            studentName: submissions[index].studentName,
            submittedAt: submissions[index].submittedAt,
            status: submissions[index].status,
            text: submissions[index].text,
            grade: clamped,
            teacherComments: submissions[index].teacherComments,
            attachments: submissions[index].attachments,
            isLate: submissions[index].isLate
        )
        refreshSelectedSubmission(submissionId: submissionId)
    }

    func addTeacherComment(for submissionId: UUID, text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard let index = submissions.firstIndex(where: { $0.id == submissionId }) else { return }

        var updatedComments = submissions[index].teacherComments
        updatedComments.append(
            TeacherReviewCommentItem(
                id: UUID(),
                authorName: item?.authorDisplayName ?? "Teacher",
                text: trimmed,
                createdAt: Date()
            )
        )

        submissions[index] = TaskSubmissionItem(
            id: submissions[index].id,
            studentName: submissions[index].studentName,
            submittedAt: submissions[index].submittedAt,
            status: submissions[index].status,
            text: submissions[index].text,
            grade: submissions[index].grade,
            teacherComments: updatedComments,
            attachments: submissions[index].attachments,
            isLate: submissions[index].isLate
        )
        refreshSelectedSubmission(submissionId: submissionId)
    }

    func deleteTeacherComment(for submissionId: UUID, commentId: UUID) {
        guard let index = submissions.firstIndex(where: { $0.id == submissionId }) else { return }

        let updatedComments = submissions[index].teacherComments.filter { $0.id != commentId }

        submissions[index] = TaskSubmissionItem(
            id: submissions[index].id,
            studentName: submissions[index].studentName,
            submittedAt: submissions[index].submittedAt,
            status: submissions[index].status,
            text: submissions[index].text,
            grade: submissions[index].grade,
            teacherComments: updatedComments,
            attachments: submissions[index].attachments,
            isLate: submissions[index].isLate
        )
        refreshSelectedSubmission(submissionId: submissionId)
    }

    func openStudentWorkSheet() {
        isStudentWorkSheetPresented = true
    }

    func openSubmissionSheet(_ submission: TaskSubmissionItem) {
        selectedSubmissionForSheet = submission
    }

    func openTaskMaterial(_ attachment: FeedAttachmentItem) {
        previewAttachment = attachment
    }

    func downloadAttachment(_ attachment: FeedAttachmentItem) {
        print("Download attachment: \(attachment.fileName)")
    }

    func shareAttachment(_ attachment: FeedAttachmentItem) {
        print("Share attachment: \(attachment.fileName)")
    }

    func uploadMaterial(from url: URL) async {
        guard isTeacher else { return }
        guard let item else { return }

        do {
            let didStartAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if didStartAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            let data = try Data(contentsOf: url)

            let uploaded = try await uploadPostMaterialUseCase.execute(
                UploadPostMaterialCommand(
                    courseId: courseId,
                    postId: postId,
                    fileName: url.lastPathComponent,
                    mimeType: contentType(for: url),
                    data: data
                )
            )

            self.item = TaskDetailItem(
                id: item.id,
                title: item.title,
                content: item.content,
                createdAt: item.createdAt,
                deadline: item.deadline,
                authorDisplayName: item.authorDisplayName,
                attachments: item.attachments + [uploaded.toFeedAttachmentItem()],
                comments: item.comments,
                teamFormationMode: item.teamFormationMode,
                teamRequirementTemplateId: item.teamRequirementTemplateId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func refreshSelectedSubmission(submissionId: UUID) {
        guard selectedSubmissionForSheet?.id == submissionId else { return }
        selectedSubmissionForSheet = submissions.first(where: { $0.id == submissionId })
    }

    private func contentType(for url: URL) -> String {
        if let typeIdentifier = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType,
           let mimeType = typeIdentifier.preferredMIMEType {
            return mimeType
        }

        return "application/octet-stream"
    }

    private static func mapPostToTaskDetailItem(
        _ post: Post,
        materials: [AttachedFile],
        comments: [Comment]
    ) -> TaskDetailItem {
        TaskDetailItem(
            id: post.id,
            title: post.title,
            content: post.content ?? "",
            createdAt: post.createdAt,
            deadline: post.deadline,
            authorDisplayName: post.author.displayName,
            attachments: materials.map { $0.toFeedAttachmentItem() },
            comments: comments.map(PostCommentItemMapper.toItem),
            teamFormationMode: post.teamFormationMode,
            teamRequirementTemplateId: post.teamRequirementTemplateId
        )
    }
}
