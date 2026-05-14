//
//  PostCommentComposerView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import SwiftUI

struct PostCommentComposerView: View {
    @Binding var text: String
    let placeholder: String
    let onSend: () -> Void

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TextField(placeholder, text: $text, axis: .vertical)
                .lineLimit(1...5)
                .padding(.leading, 14)
                .padding(.trailing, 44)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20))

            Button {
                onSend()
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(canSend ? Color.blue : Color.gray.opacity(0.5))
            }
            .buttonStyle(.plain)
            .disabled(!canSend)
            .padding(.trailing, 10)
            .padding(.bottom, 8)
        }
    }
}
