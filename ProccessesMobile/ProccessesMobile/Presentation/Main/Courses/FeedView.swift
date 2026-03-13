//
//  FeedView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel

    init(viewModel: FeedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.canCreatePost {
                    Button {
                        viewModel.createPostTapped()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create post")
                            Spacer()
                        }
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                    .buttonStyle(.plain)
                }

                ForEach(viewModel.posts) { post in
                    FeedPostCardView(
                        post: post,
                        onTap: {
                            viewModel.postTapped(post)
                        },
                        onCommentTap: {
                            viewModel.commentsTapped(for: post)
                        },
                        onAttachmentTap: { attachment in
                            viewModel.attachmentTapped(post: post, attachment: attachment)
                        }
                    )
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }
}
