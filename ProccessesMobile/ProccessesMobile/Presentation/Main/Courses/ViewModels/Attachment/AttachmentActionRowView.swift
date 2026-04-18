//
//  AttachmentActionRowView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import SwiftUI

struct AttachmentActionRowView: View {
    let attachment: FeedAttachmentItem
    let onTap: () -> Void

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
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.secondarySystemBackground))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Image(systemName: iconName)
                            .foregroundStyle(.secondary)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(attachment.fileName)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(typeLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .padding(12)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    private var typeLabel: String {
        switch attachment.type {
        case .image:
            return "Image"
        case .audio:
            return "Audio"
        case .file:
            return "File"
        }
    }
}
