//
//  StudentSubmissionSheetView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI
import UniformTypeIdentifiers

struct StudentSubmissionSheetView: View {
    let status: SubmissionStatus
    @Binding var text: String
    let attachments: [FeedAttachmentItem]
    let teacherComments: [TeacherReviewCommentItem]
    let canSubmit: Bool
    let canUnsubmit: Bool
    let onAttachFile: (URL) -> Void
    let onSubmit: () -> Void
    let onUnsubmit: () -> Void
    let onAttachmentDownload: (FeedAttachmentItem) -> Void
    let onAttachmentShare: (FeedAttachmentItem) -> Void

    @State private var selectedAttachment: FeedAttachmentItem?
    @State private var isImporterPresented = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Your work")
                                .font(.headline)

                            Spacer()

                            Text(status.title)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.12))
                                .foregroundStyle(.orange)
                                .clipShape(Capsule())
                        }

                        TextField("Add text for your submission", text: $text, axis: .vertical)
                            .lineLimit(4...8)
                            .textFieldStyle(.roundedBorder)

                        Button("Attach file") {
                            isImporterPresented = true
                        }
                        .buttonStyle(.borderedProminent)

                        if !attachments.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Attachments")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                ForEach(attachments) { attachment in
                                    AttachmentActionRowView(
                                        attachment: attachment,
                                        onTap: {
                                            selectedAttachment = attachment
                                        }
                                    )
                                }
                            }
                        }

                        HStack(spacing: 12) {
                            if canSubmit {
                                Button("Submit", action: onSubmit)
                                    .buttonStyle(.borderedProminent)
                            }

                            if canUnsubmit {
                                Button("Unsubmit", action: onUnsubmit)
                                    .buttonStyle(.bordered)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Your work")
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
            .fileImporter(
                isPresented: $isImporterPresented,
                allowedContentTypes: [.data, .content, .item, .image, .audio],
                allowsMultipleSelection: false
            ) { result in
                if case let .success(urls) = result,
                   let url = urls.first {
                    onAttachFile(url)
                }
            }
        }
    }
}
