//
//  AttachmentPreviewView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import SwiftUI

struct AttachmentPreviewView: View {
    let attachment: FeedAttachmentItem
    let onDownload: () -> Void
    let onShare: () -> Void

    private var iconName: String {
        switch attachment.type {
        case .image:
            return "photo"
        case .audio:
            return "waveform"
        case .file:
            return "doc"
        }
    }

    var body: some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()

            content
                .padding()
        }
        .navigationTitle(attachment.fileName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    onShare()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }

                Button {
                    onDownload()
                } label: {
                    Image(systemName: "arrow.down.circle")
                }
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch attachment.type {
        case .image:
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.darkGray))
                .frame(maxWidth: .infinity)
                .frame(height: 380)
                .overlay {
                    VStack(spacing: 12) {
                        Image(systemName: "photo")
                            .font(.system(size: 56))
                            .foregroundStyle(.white)

                        Text(attachment.fileName)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }

        case .audio, .file:
            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 180, height: 180)
                    .overlay {
                        Image(systemName: iconName)
                            .font(.system(size: 56))
                            .foregroundStyle(.secondary)
                    }

                Text(attachment.fileName)
                    .font(.headline)
                    .multilineTextAlignment(.center)

                Text("Preview is not available for this file type yet.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var backgroundColor: Color {
        attachment.type == .image ? .black : Color(.systemGroupedBackground)
    }
}
