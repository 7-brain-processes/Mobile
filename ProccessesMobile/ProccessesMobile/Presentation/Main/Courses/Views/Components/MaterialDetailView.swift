//
//  MaterialDetailView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI
import UniformTypeIdentifiers

struct MaterialDetailView: View {
    @StateObject private var viewModel: MaterialDetailViewModel
    @State private var isMaterialImporterPresented = false

    init(viewModel: MaterialDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            Group {
                if let item = viewModel.item {
                    content(item)
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .padding()
                } else {
                    ContentUnavailableView(
                        "Material not loaded",
                        systemImage: "exclamationmark.triangle"
                    )
                }
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
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
        .accessibilityIdentifier(AccessibilityID.MaterialDetail.screen)
        .sheet(item: $viewModel.fileToShare) { item in
            ShareSheet(items: [item.url])
        }
    }

    private func content(_ item: MaterialDetailItem) -> some View {
        VStack(spacing: 16) {
            PostDetailHeaderCard(
                iconName: "doc.text",
                iconColor: .blue,
                title: item.title,
                author: item.authorDisplayName,
                createdAt: item.createdAt,
                deadline: nil,
                description: item.content,
                titleIdentifier: AccessibilityID.MaterialDetail.title,
                authorIdentifier: AccessibilityID.MaterialDetail.author,
                dateIdentifier: AccessibilityID.MaterialDetail.date,
                deadlineIdentifier: nil,
                descriptionIdentifier: AccessibilityID.MaterialDetail.description
            )
            .padding(.horizontal, 16)

            PostAttachmentsSectionView(
                title: "Attachments",
                attachments: item.attachments,
                onAttachmentTap: { attachment in
                    viewModel.openAttachment(attachment)
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
                        await viewModel.addComment()
                    }
                },
                isSendingComment: viewModel.isPostingComment
            )
            .padding(.horizontal, 16)
        }
    }
}
