//
//  TeacherSubmissionSheetView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI

struct TeacherSubmissionSheetView: View {
    let submission: TaskSubmissionItem
    let teacherDraftComment: String
    let onDraftCommentChange: (String) -> Void
    let onApplyGrade: (String) -> Void
    let onDeleteGrade: () -> Void
    let onAddComment: () -> Void
    let onDeleteComment: (UUID) -> Void
    let onAttachmentDownload: (FeedAttachmentItem) -> Void
    let onAttachmentShare: (FeedAttachmentItem) -> Void

    @State private var selectedAttachment: FeedAttachmentItem?
    @State private var gradeInput: String
    @State private var showDeleteGradeAlert = false

    init(
        submission: TaskSubmissionItem,
        teacherDraftComment: String,
        onDraftCommentChange: @escaping (String) -> Void,
        onApplyGrade: @escaping (String) -> Void,
        onDeleteGrade: @escaping () -> Void,
        onAddComment: @escaping () -> Void,
        onDeleteComment: @escaping (UUID) -> Void,
        onAttachmentDownload: @escaping (FeedAttachmentItem) -> Void,
        onAttachmentShare: @escaping (FeedAttachmentItem) -> Void
    ) {
        self.submission = submission
        self.teacherDraftComment = teacherDraftComment
        self.onDraftCommentChange = onDraftCommentChange
        self.onApplyGrade = onApplyGrade
        self.onDeleteGrade = onDeleteGrade
        self.onAddComment = onAddComment
        self.onDeleteComment = onDeleteComment
        self.onAttachmentDownload = onAttachmentDownload
        self.onAttachmentShare = onAttachmentShare
        _gradeInput = State(initialValue: submission.grade.map(String.init) ?? "")
    }

    private var normalizedGradeBinding: Binding<String> {
        Binding(
            get: { gradeInput },
            set: { newValue in
                gradeInput = String(newValue.filter(\.isNumber).prefix(3))
            }
        )
    }

    private var parsedGrade: Int? {
        Int(gradeInput)
    }

    private var isGradeValid: Bool {
        guard let parsedGrade else { return false }
        return (0...100).contains(parsedGrade)
    }

    private var hasSavedGrade: Bool {
        submission.grade != nil
    }

    private var matchesSavedGrade: Bool {
        guard let saved = submission.grade else { return false }
        return gradeInput == String(saved)
    }

    private var showsDeleteButton: Bool {
        hasSavedGrade && matchesSavedGrade
    }

    private var gradeFieldBackground: Color {
        if gradeInput.isEmpty || isGradeValid {
            return Color(.secondarySystemBackground)
        } else {
            return Color.gray.opacity(0.22)
        }
    }

    private var gradeButtonColor: Color {
        if showsDeleteButton {
            return .red
        }

        if gradeInput.isEmpty {
            return Color.gray.opacity(0.45)
        }

        return isGradeValid ? .blue : Color.gray.opacity(0.55)
    }

    private var gradeButtonSystemImage: String {
        showsDeleteButton ? "xmark.circle.fill" : "checkmark.circle.fill"
    }

    private var isGradeButtonEnabled: Bool {
        if showsDeleteButton {
            return true
        }
        return isGradeValid
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    submissionContentCard
                    commentsCard
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Submission")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $selectedAttachment) { attachment in
                AttachmentPreviewView(
                    attachment: attachment,
                    onDownload: {
                        onAttachmentDownload(attachment)
                    },
                    onShare: {
                        onAttachmentShare(attachment)
                    }
                )
            }
            .alert("Delete grade?", isPresented: $showDeleteGradeAlert) {
                Button("Delete", role: .destructive) {
                    onDeleteGrade()
                    gradeInput = ""
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will remove the current grade for the submission.")
            }
        }
    }

    private var headerCard: some View {
        HStack(alignment: .top, spacing: 12) {
            InitialAvatarView(
                name: submission.studentName,
                size: 44,
                backgroundColor: .orange
            )

            VStack(alignment: .leading, spacing: 6) {
                Text(submission.studentName)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                if let submittedAt = submission.submittedAt {
                    Text(submittedAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                statusChip(title: submission.displayStatusTitle)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)

            HStack(spacing: 6) {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(gradeFieldBackground)

                    Button {
                        if showsDeleteButton {
                            showDeleteGradeAlert = true
                        } else {
                            guard isGradeValid else { return }
                            onApplyGrade(gradeInput)
                        }
                    } label: {
                        Image(systemName: gradeButtonSystemImage)
                            .font(.system(size: 16))
                            .foregroundStyle(gradeButtonColor)
                    }
                    .buttonStyle(.plain)
                    .disabled(!isGradeButtonEnabled)
                    .padding(.leading, 8)

                    TextField("", text: normalizedGradeBinding)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .padding(.leading, 30)
                        .padding(.trailing, 8)
                        .padding(.vertical, 8)
                }
                .frame(width: 74, height: 36)
                .layoutPriority(0)

                Text("/100")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
            }
            .fixedSize(horizontal: true, vertical: false)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var submissionContentCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Student work")
                .font(.headline)

            if !submission.text.isEmpty {
                Text(submission.text)
                    .font(.body)
                    .foregroundStyle(.primary)
            }

            if !submission.attachments.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Attachments")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    ForEach(submission.attachments) { attachment in
                        AttachmentActionRowView(
                            attachment: attachment,
                            onTap: {
                                selectedAttachment = attachment
                            }
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var commentsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Teacher comments")
                .font(.headline)

            PostCommentComposerView(
                text: Binding(
                    get: { teacherDraftComment },
                    set: onDraftCommentChange
                ),
                placeholder: "Add teacher comment",
                onSend: onAddComment
            )

            if submission.teacherComments.isEmpty {
                Text("No teacher comments yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(submission.teacherComments) { comment in
                    HStack(alignment: .top, spacing: 12) {
                        InitialAvatarView(
                            name: comment.authorName,
                            size: 30,
                            backgroundColor: .orange
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(comment.authorName)
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Text(comment.createdAt.formatted(date: .abbreviated, time: .shortened))
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(comment.text)
                                .font(.body)
                        }

                        Spacer()

                        Button(role: .destructive) {
                            onDeleteComment(comment.id)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private func statusChip(title: String) -> some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.secondarySystemBackground))
            .clipShape(Capsule())
    }
}
