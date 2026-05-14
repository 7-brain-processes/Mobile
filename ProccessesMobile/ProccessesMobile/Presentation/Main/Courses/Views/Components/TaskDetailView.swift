//
//  TaskDetailView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//

import SwiftUI

struct TaskDetailView: View {
    @StateObject private var viewModel: TaskDetailViewModel
    @State private var teacherDraftComments: [UUID: String] = [:]

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
                onAttach: {
                    viewModel.attachMockImage()
                },
                onSubmit: {
                    viewModel.submitStudentWork()
                },
                onUnsubmit: {
                    viewModel.unsubmitStudentWork()
                },
                onAttachmentDownload: { attachment in
                    viewModel.downloadAttachment(attachment)
                },
                onAttachmentShare: { attachment in
                    viewModel.shareAttachment(attachment)
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
                    viewModel.downloadAttachment(attachment)
                },
                onAttachmentShare: { attachment in
                    viewModel.shareAttachment(attachment)
                }
            )
            .presentationDetents([.medium, .large])
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
    }

    private var contentMode: TaskDetailViewModel.TeacherTab {
        viewModel.isTeacher ? viewModel.selectedTeacherTab : .task
    }

    private var taskContent: some View {
        VStack(spacing: 16) {
            PostDetailHeaderCard(
                iconName: "checklist",
                iconColor: .orange,
                title: viewModel.item.title,
                author: viewModel.item.authorDisplayName,
                createdAt: viewModel.item.createdAt,
                deadline: viewModel.item.deadline,
                description: viewModel.item.content,
                titleIdentifier: AccessibilityID.TaskDetail.title,
                authorIdentifier: AccessibilityID.TaskDetail.author,
                dateIdentifier: AccessibilityID.TaskDetail.date,
                deadlineIdentifier: AccessibilityID.TaskDetail.deadline,
                descriptionIdentifier: AccessibilityID.TaskDetail.description
            )
            .padding(.horizontal, 16)

            PostAttachmentsSectionView(
                title: "Materials",
                attachments: viewModel.item.attachments,
                onAttachmentTap: { attachment in
                    viewModel.openTaskMaterial(attachment)
                }
            )
            .padding(.horizontal, 16)

            PostCommentsSectionView(
                comments: viewModel.item.comments,
                draftComment: $viewModel.draftComment,
                onSendComment: {
                    viewModel.addPostComment()
                }
            )
            .padding(.horizontal, 16)
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
