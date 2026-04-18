//
//  ImagePreviewView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import SwiftUI

struct ImagePreviewView: View {
    let attachment: FeedAttachmentItem

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.darkGray))
                    .frame(maxWidth: .infinity)
                    .frame(height: 360)
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "photo")
                                .font(.system(size: 48))
                                .foregroundStyle(.white)

                            Text(attachment.fileName)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal, 20)

                Spacer()
            }
        }
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}
