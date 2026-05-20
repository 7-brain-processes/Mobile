//
//  MaterialDetailViewModel.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import Combine
import Foundation
import UniformTypeIdentifiers

@MainActor
final class MaterialDetailViewModel: ObservableObject {
    private let courseId: UUID
    private let postId: UUID
    private let role: CourseRole

    private let getPostUseCase: GetPostUseCase
    private let listPostMaterialsUseCase: ListPostMaterialsUseCase
    private let uploadPostMaterialUseCase: UploadPostMaterialUseCase
    private let downloadPostMaterialUseCase: DownloadPostMaterialUseCase
    private let deletePostMaterialUseCase: DeletePostMaterialUseCase
    private let listPostCommentsUseCase: ListPostCommentsUseCase
    private let createPostCommentUseCase: CreatePostCommentUseCase

    @Published var item: MaterialDetailItem?
    @Published var draftComment: String = ""
    @Published var previewAttachment: FeedAttachmentItem?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published private(set) var isPostingComment = false
    @Published var fileToShare: ShareFileItem?

    var isTeacher: Bool {
        role == .teacher
    }

    init(
        courseId: UUID,
        postId: UUID,
        role: CourseRole,
        getPostUseCase: GetPostUseCase,
        listPostMaterialsUseCase: ListPostMaterialsUseCase,
        uploadPostMaterialUseCase: UploadPostMaterialUseCase,
        downloadPostMaterialUseCase: DownloadPostMaterialUseCase,
        deletePostMaterialUseCase: DeletePostMaterialUseCase,
        listPostCommentsUseCase: ListPostCommentsUseCase,
        createPostCommentUseCase: CreatePostCommentUseCase
    ) {
        self.courseId = courseId
        self.postId = postId
        self.role = role
        self.getPostUseCase = getPostUseCase
        self.listPostMaterialsUseCase = listPostMaterialsUseCase
        self.uploadPostMaterialUseCase = uploadPostMaterialUseCase
        self.downloadPostMaterialUseCase = downloadPostMaterialUseCase
        self.deletePostMaterialUseCase = deletePostMaterialUseCase
        self.listPostCommentsUseCase = listPostCommentsUseCase
        self.createPostCommentUseCase = createPostCommentUseCase
    }

    func onAppear() {
        guard item == nil, !isLoading else { return }

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

            item = Self.mapPostToMaterialDetailItem(
                post,
                materials: materials,
                comments: commentsPage.content
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addComment(as authorName: String = "You") async {
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

    func uploadMaterial(from url: URL) async {
        guard isTeacher else { return }

        do {
            let didStartAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if didStartAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            let data = try Data(contentsOf: url)

            _ = try await uploadPostMaterialUseCase.execute(
                UploadPostMaterialCommand(
                    courseId: courseId,
                    postId: postId,
                    fileName: url.lastPathComponent,
                    mimeType: contentType(for: url),
                    data: data
                )
            )

            await reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteMaterial(_ attachment: FeedAttachmentItem) async {
        guard isTeacher else { return }

        do {
            try await deletePostMaterialUseCase.execute(
                DeletePostMaterialCommand(
                    courseId: courseId,
                    postId: postId,
                    fileId: attachment.id
                )
            )

            await reload()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func openAttachment(_ attachment: FeedAttachmentItem) {
        previewAttachment = attachment
    }

    func downloadAttachment(_ attachment: FeedAttachmentItem) {
        Task {
            do {
                let data = try await downloadPostMaterialUseCase.execute(
                    DownloadPostMaterialQuery(
                        courseId: courseId,
                        postId: postId,
                        fileId: attachment.id
                    )
                )

                let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent(attachment.fileName)

                try data.write(to: url, options: [.atomic])

                fileToShare = ShareFileItem(url: url)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func shareAttachment(_ attachment: FeedAttachmentItem) {
        downloadAttachment(attachment)
    }

    private func contentType(for url: URL) -> String {
        if let typeIdentifier = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType,
           let mimeType = typeIdentifier.preferredMIMEType {
            return mimeType
        }

        return "application/octet-stream"
    }

    private static func mapPostToMaterialDetailItem(
        _ post: Post,
        materials: [AttachedFile],
        comments: [Comment]
    ) -> MaterialDetailItem {
        MaterialDetailItem(
            id: post.id,
            title: post.title,
            content: post.content ?? "",
            createdAt: post.createdAt,
            authorDisplayName: post.author.displayName,
            attachments: materials.map { $0.toFeedAttachmentItem() },
            comments: comments.map(PostCommentItemMapper.toItem)
        )
    }
}
