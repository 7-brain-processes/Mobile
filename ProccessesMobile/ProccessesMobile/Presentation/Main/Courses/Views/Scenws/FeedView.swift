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

                if viewModel.isLoading && viewModel.posts.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else if let errorMessage = viewModel.errorMessage, viewModel.posts.isEmpty {
                    VStack(spacing: 12) {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            viewModel.refresh()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 32)
                } else if viewModel.posts.isEmpty {
                    Text("No posts yet")
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 32)
                } else {
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
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .task {
            viewModel.onAppear()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}
