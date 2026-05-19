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
    private let downloadPostMaterialUseCase: DownloadPostMaterialUseCase
    private let deletePostMaterialUseCase: DeletePostMaterialUseCase
    private let getMySolutionUseCase: GetMySolutionUseCase
    private let submitSolutionUseCase: SubmitSolutionUseCase
    private let listSolutionsUseCase: ListSolutionsUseCase
    private let gradeSolutionUseCase: GradeSolutionUseCase
    private let listSolutionFilesUseCase: ListSolutionFilesUseCase
    private let uploadSolutionFileUseCase: UploadSolutionFileUseCase
    private let deleteSolutionFileUseCase: DeleteSolutionFileUseCase
    private let downloadSolutionFileUseCase: DownloadSolutionFileUseCase

    private let listTeamRequirementTemplatesUseCase: ListTeamRequirementTemplatesUseCase
    private let listTeamsForEnrollmentUseCase: ListTeamsForEnrollmentUseCase
    private let createPostTeamUseCase: CreatePostTeamUseCase
    private let getMyTeamInPostUseCase: GetMyTeamInPostUseCase
    private let enrollStudentInTeamUseCase: EnrollStudentInTeamUseCase
    private let leaveTeamUseCase: LeaveTeamUseCase

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
    @Published var fileToShare: ShareFileItem?

    @Published private(set) var mySolutionId: UUID?
    @Published private(set) var isLoadingMySolution = false
    @Published private(set) var isSubmittingSolution = false
    @Published private(set) var isGradingSolution = false

    @Published private(set) var availableTeams: [CourseTeamAvailability] = []
    @Published private(set) var myTeam: StudentTeam?
    @Published private(set) var isLoadingTeams = false
    @Published private(set) var isChangingTeam = false
    @Published private(set) var isCreatingTeam = false
    @Published var isCreateTeamSheetPresented = false
    @Published var createTeamName = ""
    @Published var createTeamMaxSize = ""
    @Published var createTeamSelfEnrollmentEnabled = true

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
        createPostCommentUseCase: CreatePostCommentUseCase,
        getMySolutionUseCase: GetMySolutionUseCase,
        submitSolutionUseCase: SubmitSolutionUseCase,
        listSolutionsUseCase: ListSolutionsUseCase,
        gradeSolutionUseCase: GradeSolutionUseCase,
        listSolutionFilesUseCase: ListSolutionFilesUseCase,
        uploadSolutionFileUseCase: UploadSolutionFileUseCase,
        deleteSolutionFileUseCase: DeleteSolutionFileUseCase,
        downloadSolutionFileUseCase: DownloadSolutionFileUseCase,
        listTeamRequirementTemplatesUseCase: ListTeamRequirementTemplatesUseCase,
        createPostTeamUseCase: CreatePostTeamUseCase,
        listTeamsForEnrollmentUseCase: ListTeamsForEnrollmentUseCase,
        getMyTeamInPostUseCase: GetMyTeamInPostUseCase,
        enrollStudentInTeamUseCase: EnrollStudentInTeamUseCase,
        leaveTeamUseCase: LeaveTeamUseCase
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
        self.getMySolutionUseCase = getMySolutionUseCase
        self.submitSolutionUseCase = submitSolutionUseCase
        self.listSolutionsUseCase = listSolutionsUseCase
        self.gradeSolutionUseCase = gradeSolutionUseCase
        self.listSolutionFilesUseCase = listSolutionFilesUseCase
        self.uploadSolutionFileUseCase = uploadSolutionFileUseCase
        self.deleteSolutionFileUseCase = deleteSolutionFileUseCase
        self.downloadSolutionFileUseCase = downloadSolutionFileUseCase
        self.listTeamRequirementTemplatesUseCase = listTeamRequirementTemplatesUseCase
        self.createPostTeamUseCase = createPostTeamUseCase
        self.listTeamsForEnrollmentUseCase = listTeamsForEnrollmentUseCase
        self.getMyTeamInPostUseCase = getMyTeamInPostUseCase
        self.enrollStudentInTeamUseCase = enrollStudentInTeamUseCase
        self.leaveTeamUseCase = leaveTeamUseCase
    }

    var isTeacher: Bool { role == .teacher }
    var isStudent: Bool { role == .student }

    var canSubmitStudentWork: Bool {
        isStudent &&
        !isSubmittingSolution &&
        (!studentSubmissionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !studentAttachments.isEmpty) &&
        studentSubmissionStatus != .submitted &&
        studentSubmissionStatus != .accepted
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
            let teamRequirementTemplate = try await loadSelectedTeamRequirementTemplate(
                templateId: post.teamRequirementTemplateId
            )

            item = Self.mapPostToTaskDetailItem(
                post,
                materials: materials,
                comments: commentsPage.content,
                teamRequirementTemplate: teamRequirementTemplate
            )

            if isStudent {
                await loadMySolution()
            }

            await loadTeams()

            if isTeacher {
                await loadSubmissions()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private static func mapSolutionToSubmissionItem(
        _ solution: Solution,
        attachments: [FeedAttachmentItem] = []
    ) -> TaskSubmissionItem {
        TaskSubmissionItem(
            id: solution.id,
            studentName: solution.student?.displayName ?? solution.student?.username ?? "Unknown student",
            submittedAt: solution.submittedAt,
            status: mapSolutionStatusToSubmissionStatus(solution.status),
            text: solution.text ?? "",
            grade: solution.grade,
            teacherComments: [],
            attachments: attachments,
            isLate: false
        )
    }

    private static func mapSolutionStatusToSubmissionStatus(
        _ status: SolutionStatus
    ) -> SubmissionStatus {
        switch status {
        case .submitted:
            return .submitted
        case .graded:
            return .accepted
        }
    }

    private func loadSubmissions() async {
        guard isTeacher else { return }

        do {
            let page = try await listSolutionsUseCase.execute(
                ListSolutionsQuery(
                    courseId: courseId,
                    postId: postId,
                    page: 0,
                    size: 100,
                    status: nil
                )
            )

            var result: [TaskSubmissionItem] = []

            for solution in page.content {
                let files: [AttachedFile]

                if solution.filesCount > 0 {
                    files = try await listSolutionFilesUseCase.execute(
                        ListSolutionFilesQuery(
                            courseId: courseId,
                            postId: postId,
                            solutionId: solution.id
                        )
                    )
                } else {
                    files = []
                }

                result.append(
                    Self.mapSolutionToSubmissionItem(
                        solution,
                        attachments: files.map { $0.toFeedAttachmentItem() }
                    )
                )
            }

            submissions = result
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func uploadStudentAttachment(from url: URL) async {
        guard isStudent else { return }

        let solutionId: UUID

        if let existingSolutionId = mySolutionId {
            solutionId = existingSolutionId
        } else {
            let trimmed = studentSubmissionText.trimmingCharacters(in: .whitespacesAndNewlines)

            do {
                let solution = try await submitSolutionUseCase.execute(
                    SubmitSolutionCommand(
                        courseId: courseId,
                        postId: postId,
                        text: trimmed.isEmpty ? nil : trimmed
                    )
                )

                applyMySolution(solution)
                solutionId = solution.id
            } catch {
                errorMessage = error.localizedDescription
                return
            }
        }

        do {
            let didStartAccessing = url.startAccessingSecurityScopedResource()
            defer {
                if didStartAccessing {
                    url.stopAccessingSecurityScopedResource()
                }
            }

            let data = try Data(contentsOf: url)

            let uploaded = try await uploadSolutionFileUseCase.execute(
                UploadSolutionFileCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: solutionId,
                    fileName: url.lastPathComponent,
                    mimeType: contentType(for: url),
                    data: data
                )
            )

            studentAttachments.append(uploaded.toFeedAttachmentItem())
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // TODO: deleteStudentAttachment юзается?
    func deleteStudentAttachment(_ attachment: FeedAttachmentItem) async {
        guard isStudent else { return }
        guard let solutionId = mySolutionId else { return }

        do {
            try await deleteSolutionFileUseCase.execute(
                DeleteSolutionFileCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: solutionId,
                    fileId: attachment.id
                )
            )

            studentAttachments.removeAll { $0.id == attachment.id }
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func downloadStudentAttachment(_ attachment: FeedAttachmentItem) {
        guard let solutionId = mySolutionId else { return }

        Task {
            do {
                let data = try await downloadSolutionFileUseCase.execute(
                    DownloadSolutionFileQuery(
                        courseId: courseId,
                        postId: postId,
                        solutionId: solutionId,
                        fileId: attachment.id
                    )
                )

                let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent(attachment.fileName)

                try data.write(to: url, options: [.atomic])

                fileToShare = ShareFileItem(url: url)
            } catch let error as APIError {
                errorMessage = mapAPIError(error)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func downloadSubmissionAttachment(
        _ attachment: FeedAttachmentItem,
        solutionId: UUID
    ) {
        Task {
            do {
                let data = try await downloadSolutionFileUseCase.execute(
                    DownloadSolutionFileQuery(
                        courseId: courseId,
                        postId: postId,
                        solutionId: solutionId,
                        fileId: attachment.id
                    )
                )

                let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent(attachment.fileName)

                try data.write(to: url, options: [.atomic])

                fileToShare = ShareFileItem(url: url)
            } catch let error as APIError {
                errorMessage = mapAPIError(error)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func submitStudentWork() async {
        guard isStudent else { return }
        guard !isSubmittingSolution else { return }

        let trimmed = studentSubmissionText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty || !studentAttachments.isEmpty else {
            return
        }

        isSubmittingSolution = true
        errorMessage = nil

        defer {
            isSubmittingSolution = false
        }

        do {
            let solution = try await submitSolutionUseCase.execute(
                SubmitSolutionCommand(
                    courseId: courseId,
                    postId: postId,
                    text: trimmed.isEmpty ? nil : trimmed
                )
            )

            applyMySolution(solution)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func unsubmitStudentWork() {
        guard canUnsubmitStudentWork else { return }
        studentSubmissionStatus = .draft
    }

    func removeGrade(for submissionId: UUID) {
        Task {
            await removeSubmissionGrade(submissionId: submissionId)
        }
    }

    private func removeSubmissionGrade(submissionId: UUID) async {
        guard isTeacher else { return }
        guard !isGradingSolution else { return }

        isGradingSolution = true
        errorMessage = nil

        defer {
            isGradingSolution = false
        }

        do {
            let solution = try await gradeSolutionUseCase.execute(
                RemoveGradeCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: submissionId
                )
            )

            updateSubmission(with: solution)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func updateSubmission(with solution: Solution) {
        let existingAttachments = submissions
            .first(where: { $0.id == solution.id })?
            .attachments ?? []

        let updated = Self.mapSolutionToSubmissionItem(
            solution,
            attachments: existingAttachments
        )

        if let index = submissions.firstIndex(where: { $0.id == solution.id }) {
            submissions[index] = updated
        } else {
            submissions.append(updated)
        }

        if selectedSubmissionForSheet?.id == solution.id {
            selectedSubmissionForSheet = updated
        }
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

    private func loadMySolution() async {
        guard isStudent else { return }
        guard !isLoadingMySolution else { return }

        isLoadingMySolution = true
        defer { isLoadingMySolution = false }

        do {
            let solution = try await getMySolutionUseCase.execute(
                GetMySolutionQuery(
                    courseId: courseId,
                    postId: postId
                )
            )

            applyMySolution(solution)
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                mySolutionId = nil
                studentSubmissionText = ""
                studentSubmissionStatus = .draft

            default:
                errorMessage = mapAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func normalizedGradeInput(_ value: String) -> String {
        String(value.filter(\.isNumber).prefix(3))
    }

    func normalizedTeamMaxSizeInput(_ value: String) -> String {
        String(value.filter(\.isNumber).prefix(3))
    }

    func applyGrade(for submissionId: UUID, from input: String) {
        let filtered = normalizedGradeInput(input)
        guard let parsed = Int(filtered) else { return }

        Task {
            await gradeSubmission(
                submissionId: submissionId,
                grade: parsed,
                comment: nil
            )
        }
    }

    private func gradeSubmission(
        submissionId: UUID,
        grade: Int,
        comment: String?
    ) async {
        guard isTeacher else { return }
        guard !isGradingSolution else { return }

        isGradingSolution = true
        errorMessage = nil

        defer {
            isGradingSolution = false
        }

        do {
            let solution = try await gradeSolutionUseCase.execute(
                GradeSolutionCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: submissionId,
                    grade: grade,
                    comment: comment
                )
            )

            updateSubmission(with: solution)
        } catch let error as InteractionValidationError {
            errorMessage = mapInteractionValidationError(error)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func mapInteractionValidationError(_ error: InteractionValidationError) -> String {
        switch error {
        case .invalidGrade(let min, let max):
            return "Grade must be between \(min) and \(max)"

        case .invalidCommentLength(let min, let max):
            return "Comment must be between \(min) and \(max) characters"
        case .emptyId(_):
            return "Id is empty"
        }
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
                teamRequirementTemplateId: item.teamRequirementTemplateId,
                teamRequirementTemplate: item.teamRequirementTemplate
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
        comments: [Comment],
        teamRequirementTemplate: TeamRequirementTemplate?
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
            teamRequirementTemplateId: post.teamRequirementTemplateId,
            teamRequirementTemplate: teamRequirementTemplate
        )
    }

    func deleteMaterial(_ attachment: FeedAttachmentItem) async {
        guard isTeacher else { return }
        guard let item else { return }

        do {
            try await deletePostMaterialUseCase.execute(
                DeletePostMaterialCommand(
                    courseId: courseId,
                    postId: postId,
                    fileId: attachment.id
                )
            )

            self.item = TaskDetailItem(
                id: item.id,
                title: item.title,
                content: item.content,
                createdAt: item.createdAt,
                deadline: item.deadline,
                authorDisplayName: item.authorDisplayName,
                attachments: item.attachments.filter { $0.id != attachment.id },
                comments: item.comments,
                teamFormationMode: item.teamFormationMode,
                teamRequirementTemplateId: item.teamRequirementTemplateId,
                teamRequirementTemplate: item.teamRequirementTemplate
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadSelectedTeamRequirementTemplate(
        templateId: UUID?
    ) async throws -> TeamRequirementTemplate? {
        guard let templateId else { return nil }

        let templates = try await listTeamRequirementTemplatesUseCase.execute(courseId: courseId)
        return templates.first { $0.id == templateId }
    }

    private func applyMySolution(_ solution: Solution) {
        mySolutionId = solution.id
        studentSubmissionText = solution.text ?? ""

        switch solution.status {
        case .submitted:
            studentSubmissionStatus = .submitted
        case .graded:
            studentSubmissionStatus = .accepted
        }

        Task {
            await loadMySolutionFiles(solutionId: solution.id)
        }
    }

    private func loadMySolutionFiles(solutionId: UUID) async {
        do {
            let files = try await listSolutionFilesUseCase.execute(
                ListSolutionFilesQuery(
                    courseId: courseId,
                    postId: postId,
                    solutionId: solutionId
                )
            )

            studentAttachments = files.map { $0.toFeedAttachmentItem() }
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func mapAPIError(_ error: APIError) -> String {
        switch error {
        case .unauthorized:
            return "Session expired"

        case .serverError(let code):
            return "Server error: \(code)"

        case .invalidResponse:
            return "Invalid server response"

        case .underlying:
            return "Network error"

        case .invalidURL:
            return "Invalid URL"
        }
    }

    // MARK: Teams

    func loadTeams() async {
        guard item?.teamFormationMode != nil || item?.teamRequirementTemplateId != nil else { return }
        guard !isLoadingTeams else { return }

        isLoadingTeams = true
        errorMessage = nil

        defer {
            isLoadingTeams = false
        }

        do {
            availableTeams = try await listTeamsForEnrollmentUseCase.execute(
                ListTeamsForEnrollmentQuery(
                    courseId: courseId,
                    postId: postId
                )
            )

            if isStudent {
                await loadMyTeam()
            }
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var canCreateTeam: Bool {
        isTeacher &&
        !isCreatingTeam &&
        !createTeamName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func openCreateTeamSheet() {
        guard isTeacher else { return }
        createTeamName = ""
        createTeamMaxSize = ""
        createTeamSelfEnrollmentEnabled = true
        isCreateTeamSheetPresented = true
    }

    func createTeam() async {
        guard canCreateTeam else { return }

        isCreatingTeam = true
        errorMessage = nil

        defer {
            isCreatingTeam = false
        }

        do {
            let normalizedMaxSize = normalizedTeamMaxSizeInput(createTeamMaxSize)
            let maxSize = normalizedMaxSize.isEmpty ? nil : Int(normalizedMaxSize)

            let team = try await createPostTeamUseCase.execute(
                CreatePostTeamCommand(
                    courseId: courseId,
                    postId: postId,
                    name: createTeamName,
                    maxSize: maxSize,
                    selfEnrollmentEnabled: createTeamSelfEnrollmentEnabled
                )
            )

            availableTeams.append(team)
            createTeamName = ""
            createTeamMaxSize = ""
            createTeamSelfEnrollmentEnabled = true
            isCreateTeamSheetPresented = false
        } catch let error as CreatePostTeamValidationError {
            errorMessage = error.localizedDescription
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadMyTeam() async {
        guard isStudent else { return }

        do {
            myTeam = try await getMyTeamInPostUseCase.execute(
                GetMyTeamInPostQuery(
                    courseId: courseId,
                    postId: postId
                )
            )
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                myTeam = nil
            default:
                errorMessage = mapAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func enrollInTeam(_ team: CourseTeamAvailability) async {
        guard isStudent else { return }
        guard !isChangingTeam else { return }
        guard !team.isFull else { return }
        guard team.selfEnrollmentEnabled else { return }

        isChangingTeam = true
        errorMessage = nil

        defer {
            isChangingTeam = false
        }

        do {
            _ = try await enrollStudentInTeamUseCase.execute(
                EnrollStudentInTeamCommand(
                    courseId: courseId,
                    postId: postId,
                    teamId: team.id
                )
            )

            await loadTeams()
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func leaveCurrentTeam() async {
        guard isStudent else { return }
        guard !isChangingTeam else { return }
        guard let myTeam else { return }

        isChangingTeam = true
        errorMessage = nil

        defer {
            isChangingTeam = false
        }

        do {
            _ = try await leaveTeamUseCase.execute(
                LeaveTeamCommand(
                    courseId: courseId,
                    postId: postId,
                    teamId: myTeam.teamId
                )
            )

            await loadTeams()
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
