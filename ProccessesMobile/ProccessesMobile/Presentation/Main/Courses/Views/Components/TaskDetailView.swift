//
//  TaskDetailView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskDetailView: View {
    @StateObject private var viewModel: TaskDetailViewModel
    @State private var teacherDraftComments: [UUID: String] = [:]
    @State private var isMaterialImporterPresented = false

    init(viewModel: TaskDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.isTeacher {
                    Picker("Mode", selection: $viewModel.selectedTeacherTab) {
                        ForEach(TaskDetailViewModel.TeacherTab.allCases) { tab in
                            Text(tab.rawValue).tag(tab)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }

                switch contentMode {
                case .task:
                    taskContent
                case .submissions:
                    teacherSubmissionsContent
                }
            }
            .padding(.bottom, viewModel.isStudent ? 90 : 16)
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            if viewModel.isStudent {
                studentBottomBar
            }
        }
        .sheet(isPresented: $viewModel.isStudentWorkSheetPresented) {
            StudentSubmissionSheetView(
                status: viewModel.studentSubmissionStatus,
                text: $viewModel.studentSubmissionText,
                attachments: viewModel.studentAttachments,
                teacherComments: viewModel.studentTeacherComments,
                canSubmit: viewModel.canSubmitStudentWork,
                canUnsubmit: viewModel.canUnsubmitStudentWork,
                onAttachFile: { url in
                    Task {
                        await viewModel.uploadStudentAttachment(from: url)
                    }
                },
                onSubmit: {
                    Task {
                        await viewModel.submitStudentWork()
                    }
                },
                onUnsubmit: {
                    viewModel.unsubmitStudentWork()
                },
                onAttachmentDownload: { attachment in
                    viewModel.downloadStudentAttachment(attachment)
                },
                onAttachmentShare: { attachment in
                    viewModel.downloadStudentAttachment(attachment)
                }
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(item: $viewModel.selectedSubmissionForSheet) { submission in
            TeacherSubmissionSheetView(
                submission: submission,
                teacherDraftComment: teacherDraftComments[submission.id, default: ""],
                onDraftCommentChange: { teacherDraftComments[submission.id] = $0 },
                onApplyGrade: { newValue in
                    viewModel.applyGrade(for: submission.id, from: newValue)
                },
                onDeleteGrade: {
                    viewModel.removeGrade(for: submission.id)
                },
                onAddComment: {
                    let text = teacherDraftComments[submission.id, default: ""]
                    viewModel.addTeacherComment(for: submission.id, text: text)
                    teacherDraftComments[submission.id] = ""
                },
                onDeleteComment: { commentId in
                    viewModel.deleteTeacherComment(
                        for: submission.id,
                        commentId: commentId
                    )
                },
                onAttachmentDownload: { attachment in
                    viewModel.downloadSubmissionAttachment(
                        attachment,
                        solutionId: submission.id
                    )
                },
                onAttachmentShare: { attachment in
                    viewModel.downloadSubmissionAttachment(
                        attachment,
                        solutionId: submission.id
                    )
                }
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $viewModel.isCreateTeamSheetPresented) {
            createTeamSheet
                .presentationDetents([.medium])
        }
        .navigationDestination(item: Binding(
            get: { viewModel.previewAttachment },
            set: { viewModel.previewAttachment = $0 }
        )) { attachment in
            AttachmentPreviewView(
                attachment: attachment,
                onDownload: {
                    viewModel.downloadAttachment(attachment)
                },
                onShare: {
                    viewModel.shareAttachment(attachment)
                }
            )
        }
        .accessibilityIdentifier(AccessibilityID.TaskDetail.screen)
        .task {
            viewModel.onAppear()
        }
        .fileImporter(
            isPresented: $isMaterialImporterPresented,
            allowedContentTypes: [.data, .content, .item, .image, .audio],
            allowsMultipleSelection: false
        ) { result in
            if case let .success(urls) = result,
               let url = urls.first {
                Task {
                    await viewModel.uploadMaterial(from: url)
                }
            }
        }
        .sheet(item: $viewModel.fileToShare) { item in
            ShareSheet(items: [item.url])
        }
    }

    private var contentMode: TaskDetailViewModel.TeacherTab {
        viewModel.isTeacher ? viewModel.selectedTeacherTab : .task
    }

    private var taskContent: some View {
        Group {
            if let item = viewModel.item {
                VStack(spacing: 16) {
                    PostDetailHeaderCard(
                        iconName: "checklist",
                        iconColor: .orange,
                        title: item.title,
                        author: item.authorDisplayName,
                        createdAt: item.createdAt,
                        deadline: item.deadline,
                        description: item.content,
                        titleIdentifier: AccessibilityID.TaskDetail.title,
                        authorIdentifier: AccessibilityID.TaskDetail.author,
                        dateIdentifier: AccessibilityID.TaskDetail.date,
                        deadlineIdentifier: AccessibilityID.TaskDetail.deadline,
                        descriptionIdentifier: AccessibilityID.TaskDetail.description
                    )
                    .padding(.horizontal, 16)

                    if item.teamFormationMode != nil || item.teamRequirementTemplateId != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Team settings")
                                .font(.headline)

                            if let mode = item.teamFormationMode {
                                Text("Team mode: \(mode.title)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }

                            if item.teamRequirementTemplateId != nil {
                                Text("Requirements template selected")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        .background(Color(.systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                    }

                    // MARK: Student team section
                    if viewModel.isStudent {
                        TaskTeamEnrollmentSectionView(
                            myTeam: viewModel.myTeam,
                            teams: viewModel.availableTeams,
                            isLoading: viewModel.isLoadingTeams,
                            isChangingTeam: viewModel.isChangingTeam,
                            onJoin: { team in
                                Task {
                                    await viewModel.enrollInTeam(team)
                                }
                            },
                            onLeave: {
                                Task {
                                    await viewModel.leaveCurrentTeam()
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                    }

                    if viewModel.isTeacher && (item.teamFormationMode != nil || item.teamRequirementTemplateId != nil) {
                        teacherTeamManagementSection
                            .padding(.horizontal, 16)
                    }

                    // MARK: Materials section
                    PostAttachmentsSectionView(
                        title: "Materials",
                        attachments: item.attachments,
                        onAttachmentTap: { attachment in
                            viewModel.openTaskMaterial(attachment)
                        },
                        canDelete: viewModel.isTeacher,
                        onDelete: { attachment in
                            Task {
                                await viewModel.deleteMaterial(attachment)
                            }
                        }
                    )
                    .padding(.horizontal, 16)

                    if viewModel.isTeacher {
                        Button {
                            isMaterialImporterPresented = true
                        } label: {
                            Label("Attach material", systemImage: "paperclip")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .padding(.horizontal, 16)
                    }

                    PostCommentsSectionView(
                        comments: item.comments,
                        draftComment: $viewModel.draftComment,
                        onSendComment: {
                            Task {
                                await viewModel.addPostComment()
                            }
                        },
                        isSendingComment: viewModel.isPostingComment
                    )
                    .padding(.horizontal, 16)
                }
            } else if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ContentUnavailableView(
                    "Task not loaded",
                    systemImage: "exclamationmark.triangle"
                )
            }
        }
    }

    private var teacherSubmissionsContent: some View {
        VStack(spacing: 12) {
            ForEach(viewModel.submissions) { submission in
                Button {
                    viewModel.openSubmissionSheet(submission)
                } label: {
                    HStack(alignment: .top, spacing: 12) {
                        InitialAvatarView(
                            name: submission.studentName,
                            size: 40,
                            backgroundColor: .orange
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(submission.studentName)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            if let submittedAt = submission.submittedAt {
                                Text(submittedAt.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Text(submission.displayStatusTitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(submission.displayGradeText)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
        }
    }

    private var teacherTeamManagementSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Assignment teams")
                    .font(.headline)

                Spacer()

                if viewModel.isLoadingTeams {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            if viewModel.availableTeams.isEmpty && !viewModel.isLoadingTeams {
                Text("No teams created yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(viewModel.availableTeams) { team in
                    teacherTeamRow(team)
                }
            }

            Button {
                viewModel.openCreateTeamSheet()
            } label: {
                Label("Create team", systemImage: "person.3.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isCreatingTeam)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func teacherTeamRow(_ team: CourseTeamAvailability) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(team.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                Text("\(team.currentMembers)/\(team.maxSize.map(String.init) ?? "∞")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(team.selfEnrollmentEnabled ? "Self-enrollment enabled" : "Self-enrollment disabled")
                .font(.caption)
                .foregroundStyle(.secondary)

            if !team.categories.isEmpty {
                Text(team.categories.map(\.title).joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private var createTeamSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Team name", text: $viewModel.createTeamName)

                    TextField("Max size", text: Binding(
                        get: { viewModel.createTeamMaxSize },
                        set: { viewModel.createTeamMaxSize = viewModel.normalizedTeamMaxSizeInput($0) }
                    ))
                    .keyboardType(.numberPad)

                    Toggle("Allow student self-enrollment", isOn: $viewModel.createTeamSelfEnrollmentEnabled)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Create team")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.isCreateTeamSheetPresented = false
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await viewModel.createTeam()
                        }
                    } label: {
                        if viewModel.isCreatingTeam {
                            ProgressView()
                        } else {
                            Text("Create")
                        }
                    }
                    .disabled(!viewModel.canCreateTeam)
                }
            }
        }
    }

    private var studentBottomBar: some View {
        VStack(spacing: 0) {
            Divider()

            Button {
                viewModel.openStudentWorkSheet()
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Your work")
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(viewModel.studentSubmissionStatus.title)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.up")
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
            .buttonStyle(.plain)
        }
    }
}
