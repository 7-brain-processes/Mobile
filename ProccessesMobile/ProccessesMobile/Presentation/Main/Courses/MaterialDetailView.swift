//
//  MaterialDetailView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI

struct MaterialDetailView: View {
    @StateObject private var viewModel: MaterialDetailViewModel

    init(viewModel: MaterialDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                PostDetailHeaderCard(
                    iconName: "doc.text",
                    iconColor: .blue,
                    title: viewModel.item.title,
                    author: viewModel.item.authorDisplayName,
                    createdAt: viewModel.item.createdAt,
                    deadline: nil,
                    description: viewModel.item.content,
                    titleIdentifier: AccessibilityID.MaterialDetail.title,
                    authorIdentifier: AccessibilityID.MaterialDetail.author,
                    dateIdentifier: AccessibilityID.MaterialDetail.date,
                    deadlineIdentifier: nil,
                    descriptionIdentifier: AccessibilityID.MaterialDetail.description
                )
                .padding(.horizontal, 16)

                PostAttachmentsSectionView(
                    title: "Attachments",
                    attachments: viewModel.item.attachments,
                    onAttachmentTap: { attachment in
                        viewModel.openAttachment(attachment)
                    }
                )
                .padding(.horizontal, 16)

                PostCommentsSectionView(
                    comments: viewModel.item.comments,
                    draftComment: $viewModel.draftComment,
                    onSendComment: {
                        viewModel.addComment()
                    }
                )
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
        }
        .background(Color(.systemGroupedBackground))
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
    }
}
