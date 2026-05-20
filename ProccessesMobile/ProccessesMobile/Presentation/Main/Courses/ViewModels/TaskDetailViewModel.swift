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

    private enum AssessmentAPIContext {
        case config
        case criteriaGrades
        case publish
        case gradeDecomposition
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
    private let updateTeamGradeUseCase: UpdateTeamGradeUseCase
    private let getMyTeamInPostUseCase: GetMyTeamInPostUseCase
    private let enrollStudentInTeamUseCase: EnrollStudentInTeamUseCase
    private let leaveTeamUseCase: LeaveTeamUseCase
    private let listCourseTeamsUseCase: ListCourseTeamsUseCase
    private let getTeamGradeUseCase: GetTeamGradeUseCase
    private let getTeamGradeDistributionUseCase: GetTeamGradeDistributionUseCase
    private let updateTeamGradeDistributionUseCase: UpdateTeamGradeDistributionUseCase
    private let getMeUseCase: GetMeUseCase
    private let getStudentTeamGradeVoteStatusUseCase: GetStudentTeamGradeVoteStatusUseCase
    private let getTeacherTeamGradeVoteStatusUseCase: GetTeacherTeamGradeVoteStatusUseCase
    private let submitTeamGradeVoteUseCase: SubmitTeamGradeVoteUseCase
    private let finalizeTeamGradeVoteUseCase: FinalizeTeamGradeVoteUseCase
    private let getGradingConfigUseCase: GetGradingConfigUseCase
    private let updateGradingConfigUseCase: UpdateGradingConfigUseCase
    private let deleteGradingConfigUseCase: DeleteGradingConfigUseCase
    private let getCriteriaGradesUseCase: GetCriteriaGradesUseCase
    private let updateCriteriaGradesUseCase: UpdateCriteriaGradesUseCase
    private let publishCriteriaGradesUseCase: PublishCriteriaGradesUseCase
    private let getGradeDecompositionUseCase: GetGradeDecompositionUseCase

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

    @Published var assessmentConfig: AssessmentConfig?
    @Published var assessmentConfigDraft: AssessmentConfig?
    @Published var selectedAssessmentResult: AssessmentResult?
    @Published var criteriaGradesDraft: [CriterionGrade] = []
    @Published var selectedSubmissionForCriteriaSheet: TaskSubmissionItem?
    @Published var gradeBreakdown: GradeBreakdown?
    @Published private(set) var isLoadingAssessmentConfig = false
    @Published private(set) var isSavingAssessmentConfig = false
    @Published private(set) var isDeletingAssessmentConfig = false
    @Published private(set) var isLoadingCriteriaGrades = false
    @Published private(set) var isSavingCriteriaGrades = false
    @Published private(set) var isPublishingCriteriaGrades = false
    @Published private(set) var isLoadingGradeDecomposition = false
    @Published var assessmentErrorMessage: String?

    @Published private(set) var availableTeams: [CourseTeamAvailability] = []
    @Published private(set) var myTeam: StudentTeam?
    @Published private(set) var isLoadingTeams = false
    @Published private(set) var isChangingTeam = false
    @Published private(set) var isCreatingTeam = false
    @Published private(set) var isUpdatingTeamGrade = false
    @Published private(set) var isLoadingTeamGradeDistribution = false
    @Published private(set) var isUpdatingTeamGradeDistribution = false
    @Published private(set) var isLoadingTeamVoteStatus = false
    @Published private(set) var isSubmittingTeamVote = false
    @Published private(set) var isFinalizingTeamVote = false
    @Published var isCreateTeamSheetPresented = false
    @Published var isStudentVoteSheetPresented = false
    @Published var selectedTeamForGradeSheet: CourseTeamAvailability?
    @Published var createTeamName = ""
    @Published var createTeamMaxSize = ""
    @Published var createTeamSelfEnrollmentEnabled = true
    @Published private(set) var teacherTeams: [CourseTeamAvailability] = []
    @Published private(set) var teamGradeDistribution: TeamGradeDistribution?
    @Published private(set) var studentTeamGradeDistribution: TeamGradeDistribution?
    @Published private(set) var teamVoteStatus: TeamGradeVoteStatus?
    @Published private(set) var currentUser: User?
    @Published var isAssessmentConfigEditorPresented = false

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
        updateTeamGradeUseCase: UpdateTeamGradeUseCase,
        listTeamsForEnrollmentUseCase: ListTeamsForEnrollmentUseCase,
        getMyTeamInPostUseCase: GetMyTeamInPostUseCase,
        enrollStudentInTeamUseCase: EnrollStudentInTeamUseCase,
        leaveTeamUseCase: LeaveTeamUseCase,
        listCourseTeamsUseCase: ListCourseTeamsUseCase,
        getTeamGradeUseCase: GetTeamGradeUseCase,
        getTeamGradeDistributionUseCase: GetTeamGradeDistributionUseCase,
        updateTeamGradeDistributionUseCase: UpdateTeamGradeDistributionUseCase,
        getMeUseCase: GetMeUseCase,
        getStudentTeamGradeVoteStatusUseCase: GetStudentTeamGradeVoteStatusUseCase,
        getTeacherTeamGradeVoteStatusUseCase: GetTeacherTeamGradeVoteStatusUseCase,
        submitTeamGradeVoteUseCase: SubmitTeamGradeVoteUseCase,
        finalizeTeamGradeVoteUseCase: FinalizeTeamGradeVoteUseCase,
        getGradingConfigUseCase: GetGradingConfigUseCase,
        updateGradingConfigUseCase: UpdateGradingConfigUseCase,
        deleteGradingConfigUseCase: DeleteGradingConfigUseCase,
        getCriteriaGradesUseCase: GetCriteriaGradesUseCase,
        updateCriteriaGradesUseCase: UpdateCriteriaGradesUseCase,
        publishCriteriaGradesUseCase: PublishCriteriaGradesUseCase,
        getGradeDecompositionUseCase: GetGradeDecompositionUseCase
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
        self.updateTeamGradeUseCase = updateTeamGradeUseCase
        self.listTeamsForEnrollmentUseCase = listTeamsForEnrollmentUseCase
        self.getMyTeamInPostUseCase = getMyTeamInPostUseCase
        self.enrollStudentInTeamUseCase = enrollStudentInTeamUseCase
        self.leaveTeamUseCase = leaveTeamUseCase
        self.listCourseTeamsUseCase = listCourseTeamsUseCase
        self.getTeamGradeUseCase = getTeamGradeUseCase
        self.getTeamGradeDistributionUseCase = getTeamGradeDistributionUseCase
        self.updateTeamGradeDistributionUseCase = updateTeamGradeDistributionUseCase
        self.getMeUseCase = getMeUseCase
        self.getStudentTeamGradeVoteStatusUseCase = getStudentTeamGradeVoteStatusUseCase
        self.getTeacherTeamGradeVoteStatusUseCase = getTeacherTeamGradeVoteStatusUseCase
        self.submitTeamGradeVoteUseCase = submitTeamGradeVoteUseCase
        self.finalizeTeamGradeVoteUseCase = finalizeTeamGradeVoteUseCase
        self.getGradingConfigUseCase = getGradingConfigUseCase
        self.updateGradingConfigUseCase = updateGradingConfigUseCase
        self.deleteGradingConfigUseCase = deleteGradingConfigUseCase
        self.getCriteriaGradesUseCase = getCriteriaGradesUseCase
        self.updateCriteriaGradesUseCase = updateCriteriaGradesUseCase
        self.publishCriteriaGradesUseCase = publishCriteriaGradesUseCase
        self.getGradeDecompositionUseCase = getGradeDecompositionUseCase
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

    var studentDistributionModeTitle: String {
        if teamVoteStatus != nil {
            return TeamGradeDistributionMode.teamVote.title
        }

        return studentTeamGradeDistribution?.distributionMode.title ?? "Manual"
    }

    var studentVotingStatusTitle: String? {
        guard teamVoteStatus != nil else { return nil }
        return teamVoteStatus?.state.title ?? "Not started"
    }

    func updateAssessmentMaxGradeDraft(_ input: String) {
        guard let draft = assessmentConfigDraft else { return }

        let normalized = input.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized) else { return }

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: value,
            criteria: draft.criteria,
            modifiers: draft.modifiers,
            resultsVisible: draft.resultsVisible
        )
    }

    func updateAssessmentResultsVisibleDraft(_ value: Bool) {
        guard let draft = assessmentConfigDraft else { return }

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria,
            modifiers: draft.modifiers,
            resultsVisible: value
        )
    }

    var studentVotingActionTitle: String {
        if teamVoteStatus?.canSubmitVote == true {
            return "Vote now"
        }

        return "Open voting"
    }

    var studentVotingPrompt: String? {
        guard teamVoteStatus != nil else { return nil }

        if teamVoteStatus?.canSubmitVote == true {
            return "Your team is waiting for your vote"
        }

        if teamVoteStatus?.finalized == true {
            return "Voting is complete"
        }

        if teamVoteStatus?.myVote.isEmpty == false {
            return "Your vote has been submitted"
        }

        return "Voting is in progress"
    }

    var studentOwnGradeLabel: String? {
        guard let currentUser else { return nil }

        if let finalGrade = teamVoteStatus?.finalDistribution.first(where: { $0.student.id == currentUser.id })?.grade {
            return "Your final grade: \(finalGrade)/100"
        }

        if let votedGrade = teamVoteStatus?.myVote.first(where: { $0.student.id == currentUser.id })?.grade {
            return "Your vote for yourself: \(votedGrade)/100"
        }

        if let distributedGrade = studentTeamGradeDistribution?.students.first(where: { $0.student.id == currentUser.id })?.grade {
            return "Your individual grade: \(distributedGrade)/100"
        }

        return nil
    }

    var canOpenStudentVoteSheet: Bool {
        isStudent && myTeam != nil && teamVoteStatus != nil
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

            let teamRequirementTemplate: TeamRequirementTemplate?

            if isTeacher {
                teamRequirementTemplate = try await loadSelectedTeamRequirementTemplate(
                    templateId: post.teamRequirementTemplateId
                )
            } else {
                teamRequirementTemplate = nil
            }

            item = Self.mapPostToTaskDetailItem(
                post,
                materials: materials,
                comments: commentsPage.content,
                teamRequirementTemplate: teamRequirementTemplate
            )

            if isTeacher {
                await loadAssessmentConfig()
            }

            if isStudent {
                currentUser = try? await getMeUseCase.execute()
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
            studentId: solution.student?.id,
            studentName: solution.student?.displayName ?? solution.student?.username ?? "Unknown student",
            submittedAt: solution.submittedAt,
            status: mapSolutionStatusToSubmissionStatus(solution.status),
            text: solution.text ?? "",
            grade: solution.grade,
            isTeamManagedGrade: false,
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

    func openAssessmentConfigEditor() {
        guard isTeacher else { return }
        resetAssessmentConfigDraft()
        assessmentErrorMessage = nil
        isAssessmentConfigEditorPresented = true
    }

    func closeAssessmentConfigEditor() {
        isAssessmentConfigEditorPresented = false
    }

    func resetAssessmentConfigDraft() {
        assessmentConfigDraft = assessmentConfig ?? AssessmentConfig(
            maxGrade: 100,
            criteria: [],
            modifiers: [],
            resultsVisible: false
        )
    }

    func addCriterionDraft(_ criterion: AssessmentCriterion) {
        guard let draft = assessmentConfigDraft else {
            resetAssessmentConfigDraft()
            addCriterionDraft(criterion)
            return
        }

        let criterionWithId = AssessmentCriterion(
            id: criterion.id ?? UUID(),
            title: criterion.title,
            type: criterion.type,
            maxPoints: criterion.maxPoints,
            weight: criterion.weight,
            commentEnabled: criterion.commentEnabled
        )

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria + [criterionWithId],
            modifiers: draft.modifiers,
            resultsVisible: draft.resultsVisible
        )
    }

    func removeCriterionDraft(id: UUID) {
        guard let draft = assessmentConfigDraft else { return }

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria.filter { $0.id != id },
            modifiers: draft.modifiers,
            resultsVisible: draft.resultsVisible
        )
    }

    func updateCriterionDraft(_ criterion: AssessmentCriterion) {
        guard let draft = assessmentConfigDraft else { return }
        guard let id = criterion.id else { return }

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria.map { $0.id == id ? criterion : $0 },
            modifiers: draft.modifiers,
            resultsVisible: draft.resultsVisible
        )
    }

    func addModifierDraft(_ modifier: AssessmentModifier) {
        guard let draft = assessmentConfigDraft else {
            resetAssessmentConfigDraft()
            addModifierDraft(modifier)
            return
        }

        let modifierWithId = AssessmentModifier(
            id: modifier.id ?? UUID(),
            type: modifier.type,
            enabled: modifier.enabled,
            softDeadline: modifier.softDeadline,
            hardDeadline: modifier.hardDeadline,
            softDeadlineBonus: modifier.softDeadlineBonus,
            earlySubmissionBonusPerDay: modifier.earlySubmissionBonusPerDay,
            latePenaltyPerDay: modifier.latePenaltyPerDay,
            maxLatePenaltyDays: modifier.maxLatePenaltyDays,
            formula: modifier.formula,
            checkpointCount: modifier.checkpointCount,
            pointsPerCheckpoint: modifier.pointsPerCheckpoint,
            description: modifier.description
        )

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria,
            modifiers: draft.modifiers + [modifierWithId],
            resultsVisible: draft.resultsVisible
        )
    }

    func removeModifierDraft(id: UUID) {
        guard let draft = assessmentConfigDraft else { return }

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria,
            modifiers: draft.modifiers.filter { $0.id != id },
            resultsVisible: draft.resultsVisible
        )
    }

    func updateModifierDraft(_ modifier: AssessmentModifier) {
        guard let draft = assessmentConfigDraft else { return }

        assessmentConfigDraft = AssessmentConfig(
            id: draft.id,
            maxGrade: draft.maxGrade,
            criteria: draft.criteria,
            modifiers: draft.modifiers.map { existing in
                let isSameModifier: Bool

                if let modifierId = modifier.id {
                    isSameModifier = existing.id == modifierId
                } else {
                    isSameModifier = existing.type == modifier.type
                }

                guard isSameModifier else { return existing }

                return AssessmentModifier(
                    id: modifier.id ?? existing.id,
                    type: modifier.type,
                    enabled: modifier.enabled,
                    softDeadline: modifier.softDeadline,
                    hardDeadline: modifier.hardDeadline,
                    softDeadlineBonus: modifier.softDeadlineBonus,
                    earlySubmissionBonusPerDay: modifier.earlySubmissionBonusPerDay,
                    latePenaltyPerDay: modifier.latePenaltyPerDay,
                    maxLatePenaltyDays: modifier.maxLatePenaltyDays,
                    formula: modifier.formula,
                    checkpointCount: modifier.checkpointCount,
                    pointsPerCheckpoint: modifier.pointsPerCheckpoint,
                    description: modifier.description
                )
            },
            resultsVisible: draft.resultsVisible
        )
    }

    func saveAssessmentConfig() async {
        guard isTeacher else { return }
        guard !isSavingAssessmentConfig else { return }
        guard let draft = assessmentConfigDraft else { return }

        isSavingAssessmentConfig = true
        assessmentErrorMessage = nil

        defer {
            isSavingAssessmentConfig = false
        }

        do {
            let saved = try await updateGradingConfigUseCase.execute(
                UpsertGradingConfigCommand(
                    courseId: courseId,
                    postId: postId,
                    config: draft
                )
            )

            assessmentConfig = saved
            assessmentConfigDraft = saved
            isAssessmentConfigEditorPresented = false
        } catch let error as AssessmentValidationError {
            assessmentErrorMessage = error.localizedDescription
        } catch let error as APIError {
            assessmentErrorMessage = mapAssessmentAPIError(error, context: .config)
        } catch {
            assessmentErrorMessage = error.localizedDescription
        }
    }

    func deleteAssessmentConfig() async {
        guard isTeacher else { return }
        guard !isDeletingAssessmentConfig else { return }

        isDeletingAssessmentConfig = true
        assessmentErrorMessage = nil

        defer {
            isDeletingAssessmentConfig = false
        }

        do {
            try await deleteGradingConfigUseCase.execute(
                DeleteGradingConfigCommand(
                    courseId: courseId,
                    postId: postId
                )
            )

            assessmentConfig = nil
            assessmentConfigDraft = nil
            isAssessmentConfigEditorPresented = false
        } catch let error as APIError {
            assessmentErrorMessage = mapAssessmentAPIError(error, context: .config)
        } catch {
            assessmentErrorMessage = error.localizedDescription
        }
    }

    func openCriteriaGrading(for submission: TaskSubmissionItem) async {
        guard isTeacher else { return }
        guard !isLoadingCriteriaGrades else { return }

        selectedSubmissionForSheet = nil
        selectedSubmissionForCriteriaSheet = submission
        selectedAssessmentResult = nil
        criteriaGradesDraft = []
        assessmentErrorMessage = nil

        guard assessmentConfig != nil else {
            return
        }

        isLoadingCriteriaGrades = true

        defer {
            isLoadingCriteriaGrades = false
        }

        do {
            let result = try await getCriteriaGradesUseCase.execute(
                GetCriteriaGradesQuery(
                    courseId: courseId,
                    postId: postId,
                    solutionId: submission.id
                )
            )

            selectedAssessmentResult = result
            criteriaGradesDraft = result.criteriaGrades
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                selectedAssessmentResult = nil
                criteriaGradesDraft = []
                assessmentErrorMessage = "No criteria grades have been saved for this submission yet"
            default:
                assessmentErrorMessage = mapAssessmentAPIError(error, context: .criteriaGrades)
            }
        } catch {
            assessmentErrorMessage = error.localizedDescription
        }
    }

    func closeCriteriaGrading() {
        selectedSubmissionForCriteriaSheet = nil
    }

    func criteriaGradeDraft(for criterionId: UUID?) -> CriterionGrade? {
        guard let criterionId else { return nil }
        return criteriaGradesDraft.first { $0.criterionId == criterionId }
    }

    func updateCriteriaGradeDraft(
        criterionId: UUID?,
        value: Double? = nil,
        comment: String? = nil
    ) {
        guard let criterionId else { return }

        let existing = criteriaGradesDraft.first { $0.criterionId == criterionId }
        let updated = CriterionGrade(
            criterionId: criterionId,
            value: value ?? existing?.value ?? 0,
            comment: comment ?? existing?.comment
        )

        if let index = criteriaGradesDraft.firstIndex(where: { $0.criterionId == criterionId }) {
            criteriaGradesDraft[index] = updated
        } else {
            criteriaGradesDraft.append(updated)
        }
    }

    func updateCriteriaGradeValueDraft(
        criterionId: UUID?,
        value: Double
    ) {
        updateCriteriaGradeDraft(
            criterionId: criterionId,
            value: value
        )
    }

    func updateCriteriaGradeCommentDraft(
        criterionId: UUID?,
        comment: String?
    ) {
        guard let criterionId else { return }

        let existing = criteriaGradesDraft.first { $0.criterionId == criterionId }
        let updated = CriterionGrade(
            criterionId: criterionId,
            value: existing?.value ?? 0,
            comment: comment
        )

        if let index = criteriaGradesDraft.firstIndex(where: { $0.criterionId == criterionId }) {
            criteriaGradesDraft[index] = updated
        } else {
            criteriaGradesDraft.append(updated)
        }
    }

    func saveCriteriaGrades() async {
        guard isTeacher else { return }
        guard !isSavingCriteriaGrades else { return }
        guard let submission = selectedSubmissionForCriteriaSheet else { return }

        isSavingCriteriaGrades = true
        assessmentErrorMessage = nil

        defer {
            isSavingCriteriaGrades = false
        }

        do {
            let result = try await updateCriteriaGradesUseCase.execute(
                UpdateCriteriaGradesCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: submission.id,
                    grades: criteriaGradesDraft,
                    config: assessmentConfig
                )
            )

            selectedAssessmentResult = result
            criteriaGradesDraft = result.criteriaGrades
        } catch let error as AssessmentValidationError {
            assessmentErrorMessage = error.localizedDescription
        } catch let error as APIError {
            assessmentErrorMessage = mapAssessmentAPIError(error, context: .criteriaGrades)
        } catch {
            assessmentErrorMessage = error.localizedDescription
        }
    }

    func publishCriteriaGrades() async {
        guard isTeacher else { return }
        guard !isPublishingCriteriaGrades else { return }
        guard let submission = selectedSubmissionForCriteriaSheet else { return }

        isPublishingCriteriaGrades = true
        assessmentErrorMessage = nil

        defer {
            isPublishingCriteriaGrades = false
        }

        do {
            let result = try await publishCriteriaGradesUseCase.execute(
                PublishCriteriaGradesCommand(
                    courseId: courseId,
                    postId: postId,
                    solutionId: submission.id
                )
            )

            selectedAssessmentResult = result
            criteriaGradesDraft = result.criteriaGrades
            await loadSubmissions()
        } catch let error as APIError {
            assessmentErrorMessage = mapAssessmentAPIError(error, context: .publish)
        } catch {
            assessmentErrorMessage = error.localizedDescription
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
            await applyTeacherTeamGradesToSubmissions()
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

        Task {
            await applyTeacherTeamGradesToSubmissions()
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
            await loadMyGradeDecomposition()
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                mySolutionId = nil
                gradeBreakdown = nil
                studentSubmissionText = ""
                studentSubmissionStatus = .draft

            default:
                errorMessage = mapAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadMyGradeDecomposition() async {
        guard isStudent else { return }
        guard mySolutionId != nil else {
            gradeBreakdown = nil
            return
        }
        guard !isLoadingGradeDecomposition else { return }

        isLoadingGradeDecomposition = true
        assessmentErrorMessage = nil

        defer {
            isLoadingGradeDecomposition = false
        }

        do {
            gradeBreakdown = try await getGradeDecompositionUseCase.execute(
                GetGradeDecompositionQuery(
                    courseId: courseId,
                    postId: postId
                )
            )
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                gradeBreakdown = nil

            default:
                assessmentErrorMessage = mapAssessmentAPIError(error, context: .gradeDecomposition)
            }
        } catch {
            assessmentErrorMessage = error.localizedDescription
        }
    }

    func normalizedGradeInput(_ value: String) -> String {
        String(value.filter(\.isNumber).prefix(3))
    }

    func normalizedTeamMaxSizeInput(_ value: String) -> String {
        String(value.filter(\.isNumber).prefix(3))
    }

    func normalizedTeamGradeInput(_ value: String) -> String {
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
            studentId: submissions[index].studentId,
            studentName: submissions[index].studentName,
            submittedAt: submissions[index].submittedAt,
            status: submissions[index].status,
            text: submissions[index].text,
            grade: submissions[index].grade,
            isTeamManagedGrade: submissions[index].isTeamManagedGrade,
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
            studentId: submissions[index].studentId,
            studentName: submissions[index].studentName,
            submittedAt: submissions[index].submittedAt,
            status: submissions[index].status,
            text: submissions[index].text,
            grade: submissions[index].grade,
            isTeamManagedGrade: submissions[index].isTeamManagedGrade,
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

    private func loadAssessmentConfig() async {
        guard isTeacher else { return }
        guard !isLoadingAssessmentConfig else { return }

        isLoadingAssessmentConfig = true
        assessmentErrorMessage = nil

        defer {
            isLoadingAssessmentConfig = false
        }

        do {
            let config = try await getGradingConfigUseCase.execute(
                GetGradingConfigQuery(
                    courseId: courseId,
                    postId: postId
                )
            )

            assessmentConfig = config
            assessmentConfigDraft = config
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                assessmentConfig = nil
                assessmentConfigDraft = nil

            default:
                assessmentErrorMessage = mapAssessmentAPIError(error, context: .config)
            }
        } catch {
            assessmentErrorMessage = error.localizedDescription
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

    private func mapAssessmentAPIError(
        _ error: APIError,
        context: AssessmentAPIContext
    ) -> String {
        switch error {
        case .unauthorized:
            return "Session expired"

        case .serverError(let code):
            return mapAssessmentServerError(code, context: context)

        case .invalidResponse:
            return invalidAssessmentResponseMessage(context: context)

        case .underlying:
            return networkAssessmentErrorMessage(context: context)

        case .invalidURL:
            return invalidAssessmentURLMessage(context: context)
        }
    }

    private func mapAssessmentServerError(
        _ code: Int,
        context: AssessmentAPIContext
    ) -> String {
        switch code {
        case 400:
            switch context {
            case .config:
                return "Invalid assessment configuration"
            case .criteriaGrades:
                return "Invalid criteria grades"
            case .publish:
                return "No criteria grades are ready to publish"
            case .gradeDecomposition:
                return "Invalid grade decomposition request"
            }

        case 403:
            return "You do not have permission to use this assessment action"

        case 404:
            switch context {
            case .config:
                return "Assessment config is not configured"
            case .criteriaGrades:
                return "Criteria grades were not found for this submission"
            case .publish:
                return "Cannot publish because criteria grades were not found"
            case .gradeDecomposition:
                return "Grade decomposition is not available"
            }

        case 409:
            return "Assessment state has changed. Reload and try again"

        default:
            switch context {
            case .config:
                return "Assessment config error: \(code)"
            case .criteriaGrades:
                return "Criteria grades error: \(code)"
            case .publish:
                return "Criteria grades publish error: \(code)"
            case .gradeDecomposition:
                return "Grade decomposition error: \(code)"
            }
        }
    }

    private func invalidAssessmentResponseMessage(context: AssessmentAPIContext) -> String {
        switch context {
        case .config:
            return "Invalid assessment config response"
        case .criteriaGrades:
            return "Invalid criteria grades response"
        case .publish:
            return "Invalid published assessment response"
        case .gradeDecomposition:
            return "Invalid grade decomposition response"
        }
    }

    private func networkAssessmentErrorMessage(context: AssessmentAPIContext) -> String {
        switch context {
        case .config:
            return "Network error while loading assessment config"
        case .criteriaGrades:
            return "Network error while loading criteria grades"
        case .publish:
            return "Network error while publishing criteria grades"
        case .gradeDecomposition:
            return "Network error while loading grade decomposition"
        }
    }

    private func invalidAssessmentURLMessage(context: AssessmentAPIContext) -> String {
        switch context {
        case .config:
            return "Invalid assessment config URL"
        case .criteriaGrades:
            return "Invalid criteria grades URL"
        case .publish:
            return "Invalid criteria grades publish URL"
        case .gradeDecomposition:
            return "Invalid grade decomposition URL"
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

    private func mapVotingAPIError(_ error: APIError) -> String {
        switch error {
        case .serverError(let code):
            switch code {
            case 400:
                return "The submitted vote is invalid"
            case 403:
                return "You cannot vote in this team"
            case 404:
                return "Voting is not available for this assignment yet"
            case 409:
                return "This action is no longer available"
            default:
                return mapAPIError(error)
            }
        default:
            return mapAPIError(error)
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
            if isStudent {
                let fetchedTeams = try await listTeamsForEnrollmentUseCase.execute(
                    ListTeamsForEnrollmentQuery(
                        courseId: courseId,
                        postId: postId
                    )
                )
                availableTeams = fetchedTeams

                await loadMyTeam()

                if let myTeam {
                    self.myTeam = myTeam
                    await loadStudentDistributionAndVote(teamId: myTeam.teamId)
                } else {
                    studentTeamGradeDistribution = nil
                    teamVoteStatus = nil
                }
            }

            if isTeacher {
                let fetchedTeams = try await listCourseTeamsUseCase.execute(courseId: courseId)
                    .map { $0.toAvailabilityItem() }
                teacherTeams = await hydrateTeamGrades(in: fetchedTeams)
            }
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func hydrateTeamGrades(
        in teams: [CourseTeamAvailability]
    ) async -> [CourseTeamAvailability] {
        var result: [CourseTeamAvailability] = []
        result.reserveCapacity(teams.count)

        for team in teams {
            let teamGrade = await fetchTeamGrade(for: team.id) ?? team.teamGrade
            result.append(team.withTeamGrade(teamGrade))
        }

        return result
    }

    private func hydrateMyTeamGrade(_ team: StudentTeam) async -> StudentTeam {
        let teamGrade = await fetchTeamGrade(for: team.teamId) ?? team.teamGrade
        return team.withTeamGrade(teamGrade)
    }

    private func fetchTeamGrade(for teamId: UUID) async -> Int? {
        do {
            let teamGrade = try await getTeamGradeUseCase.execute(
                courseId: courseId,
                postId: postId,
                teamId: teamId
            )

            return teamGrade.grade
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                return nil
            default:
                return nil
            }
        } catch {
            return nil
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

    func openTeamGradeSheet(_ team: CourseTeamAvailability) {
        guard isTeacher else { return }
        selectedTeamForGradeSheet = team
        teamGradeDistribution = nil
        teamVoteStatus = nil

        Task {
            await loadTeacherTeamSheetData(for: team.id)
        }
    }

    func openStudentVoteSheet() {
        guard canOpenStudentVoteSheet else { return }
        isStudentVoteSheetPresented = true
    }

    func updateTeamGrade(for teamId: UUID, from input: String) async {
        guard isTeacher else { return }
        guard !isUpdatingTeamGrade else { return }

        let normalized = normalizedTeamGradeInput(input)
        guard let grade = Int(normalized) else { return }

        isUpdatingTeamGrade = true
        errorMessage = nil

        defer {
            isUpdatingTeamGrade = false
        }

        do {
            _ = try await updateTeamGradeUseCase.execute(
                UpdateTeamGradeCommand(
                    courseId: courseId,
                    postId: postId,
                    teamId: teamId,
                    grade: grade,
                    comment: nil
                )
            )

            await loadTeams()
            await loadTeacherTeamSheetData(for: teamId)

            selectedTeamForGradeSheet = nil
        } catch let error as InteractionValidationError {
            errorMessage = mapInteractionValidationError(error)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func updateLocalTeamGrade(
        teamId: UUID,
        grade: Int?
    ) {
        guard let index = teacherTeams.firstIndex(where: { $0.id == teamId }) else {
            return
        }

        let current = teacherTeams[index]

        let updated = CourseTeamAvailability(
            id: current.id,
            name: current.name,
            teamGrade: grade,
            currentMembers: current.currentMembers,
            maxSize: current.maxSize,
            selfEnrollmentEnabled: current.selfEnrollmentEnabled,
            isFull: current.isFull,
            isStudentMember: current.isStudentMember,
            categories: current.categories,
            createdAt: current.createdAt
        )

        teacherTeams[index] = updated

        if selectedTeamForGradeSheet?.id == teamId {
            selectedTeamForGradeSheet = updated
        }
    }

    func applyAutoEqualDistribution(for teamId: UUID) async {
        guard isTeacher else { return }
        guard !isUpdatingTeamGradeDistribution else { return }

        isUpdatingTeamGradeDistribution = true
        errorMessage = nil

        defer {
            isUpdatingTeamGradeDistribution = false
        }

        do {
            let distribution = try await updateTeamGradeDistributionUseCase.execute(
                UpdateTeamGradeDistributionCommand(
                    courseId: courseId,
                    postId: postId,
                    teamId: teamId,
                    distributionMode: .autoEqual
                )
            )

            teamGradeDistribution = distribution
            await loadTeams()
            selectedTeamForGradeSheet = teacherTeams.first(where: { $0.id == teamId })
            await loadTeacherTeamVoteStatus(for: teamId)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func applyTeamVoteDistribution(for teamId: UUID) async {
        guard isTeacher else { return }
        guard !isUpdatingTeamGradeDistribution else { return }

        isUpdatingTeamGradeDistribution = true
        errorMessage = nil

        defer {
            isUpdatingTeamGradeDistribution = false
        }

        do {
            let distribution = try await updateTeamGradeDistributionUseCase.execute(
                UpdateTeamGradeDistributionCommand(
                    courseId: courseId,
                    postId: postId,
                    teamId: teamId,
                    distributionMode: .teamVote
                )
            )

            teamGradeDistribution = distribution
            await loadTeams()
            selectedTeamForGradeSheet = teacherTeams.first(where: { $0.id == teamId })
            await loadTeacherTeamVoteStatus(for: teamId)
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadTeamGradeDistribution(for teamId: UUID) async {
        guard !isLoadingTeamGradeDistribution else { return }

        isLoadingTeamGradeDistribution = true
        errorMessage = nil

        defer {
            isLoadingTeamGradeDistribution = false
        }

        do {
            let distribution = try await getTeamGradeDistributionUseCase.execute(
                courseId: courseId,
                postId: postId,
                teamId: teamId
            )

            teamGradeDistribution = distribution

            updateLocalTeamGrade(
                teamId: teamId,
                grade: distribution.teamGrade
            )

            selectedTeamForGradeSheet = teacherTeams.first(where: { $0.id == teamId }) ?? selectedTeamForGradeSheet
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                teamGradeDistribution = nil
            default:
                errorMessage = mapAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadStudentDistributionAndVote(teamId: UUID) async {
        studentTeamGradeDistribution = nil
        await loadStudentVoteStatus()
    }

    private func loadTeacherTeamSheetData(for teamId: UUID) async {
        async let distributionTask: Void = loadTeamGradeDistribution(for: teamId)
        async let voteTask: Void = loadTeacherTeamVoteStatus(for: teamId)
        _ = await (distributionTask, voteTask)
    }

    private func loadStudentTeamGradeDistribution(for teamId: UUID) async {
        guard !isLoadingTeamGradeDistribution else { return }

        isLoadingTeamGradeDistribution = true
        defer { isLoadingTeamGradeDistribution = false }

        do {
            studentTeamGradeDistribution = try await getTeamGradeDistributionUseCase.execute(
                courseId: courseId,
                postId: postId,
                teamId: teamId
            )
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 403:
                studentTeamGradeDistribution = nil
            case .serverError(let code) where code == 404:
                studentTeamGradeDistribution = nil
            default:
                errorMessage = mapAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadStudentVoteStatus() async {
        guard !isLoadingTeamVoteStatus else { return }

        isLoadingTeamVoteStatus = true
        defer { isLoadingTeamVoteStatus = false }

        do {
            teamVoteStatus = try await getStudentTeamGradeVoteStatusUseCase.execute(
                courseId: courseId,
                postId: postId
            )

            if let teamVoteStatus {
                if let myTeam, myTeam.teamId == teamVoteStatus.teamId {
                    self.myTeam = myTeam.withTeamGrade(teamVoteStatus.teamGrade)
                }

                if let index = availableTeams.firstIndex(where: { $0.id == teamVoteStatus.teamId }) {
                    availableTeams[index] = availableTeams[index].withTeamGrade(teamVoteStatus.teamGrade)
                }
            }
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                teamVoteStatus = nil
            default:
                errorMessage = mapVotingAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadTeacherTeamVoteStatus(for teamId: UUID) async {
        guard !isLoadingTeamVoteStatus else { return }

        isLoadingTeamVoteStatus = true
        defer { isLoadingTeamVoteStatus = false }

        do {
            teamVoteStatus = try await getTeacherTeamGradeVoteStatusUseCase.execute(
                courseId: courseId,
                postId: postId,
                teamId: teamId
            )
        } catch let error as APIError {
            switch error {
            case .serverError(let code) where code == 404:
                teamVoteStatus = nil
            default:
                errorMessage = mapVotingAPIError(error)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submitTeamVote(_ grades: [StudentGradeVoteEntry]) async {
        guard isStudent else { return }
        guard !isSubmittingTeamVote else { return }

        isSubmittingTeamVote = true
        errorMessage = nil

        defer {
            isSubmittingTeamVote = false
        }

        do {
            teamVoteStatus = try await submitTeamGradeVoteUseCase.execute(
                SubmitTeamGradeVoteCommand(
                    courseId: courseId,
                    postId: postId,
                    grades: grades
                )
            )

            if let myTeam {
                await loadStudentDistributionAndVote(teamId: myTeam.teamId)
            }
        } catch let error as APIError {
            errorMessage = mapVotingAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func finalizeTeamVote(for teamId: UUID) async {
        guard isTeacher else { return }
        guard !isFinalizingTeamVote else { return }

        isFinalizingTeamVote = true
        errorMessage = nil

        defer {
            isFinalizingTeamVote = false
        }

        do {
            teamVoteStatus = try await finalizeTeamGradeVoteUseCase.execute(
                courseId: courseId,
                postId: postId,
                teamId: teamId
            )

            await loadTeams()
            await loadTeacherTeamSheetData(for: teamId)
            await loadSubmissions()
        } catch let error as APIError {
            errorMessage = mapVotingAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func applyTeacherTeamGradesToSubmissions() async {
        guard isTeacher else { return }
        guard !teacherTeams.isEmpty else { return }
        guard !submissions.isEmpty else { return }

        var gradesByStudentId: [UUID: Int] = [:]

        for team in teacherTeams where team.currentMembers > 0 {
            do {
                let voteStatus = try await getTeacherTeamGradeVoteStatusUseCase.execute(
                    courseId: courseId,
                    postId: postId,
                    teamId: team.id
                )

                for item in voteStatus.finalDistribution {
                    if let grade = item.grade {
                        gradesByStudentId[item.student.id] = grade
                    }
                }
            } catch {
                continue
            }
        }

        submissions = submissions.map { submission in
            guard let studentId = submission.studentId,
                  let grade = gradesByStudentId[studentId] else {
                return submission
            }

            return submission.withGrade(grade, isTeamManagedGrade: true)
        }

        if let selectedSubmissionForSheet {
            self.selectedSubmissionForSheet = submissions.first(where: { $0.id == selectedSubmissionForSheet.id })
        }
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

            teacherTeams.append(team)
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
            studentTeamGradeDistribution = nil
            teamVoteStatus = nil
        } catch let error as APIError {
            errorMessage = mapAPIError(error)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
