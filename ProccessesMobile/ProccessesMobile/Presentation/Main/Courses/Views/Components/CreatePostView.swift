//
//  CreatePostView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreatePostView: View {
    @StateObject private var viewModel: CreatePostViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var isImporterPresented = false

    init(viewModel: CreatePostViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Form {
            Section("Content") {
                TextField("Title", text: $viewModel.title)

                TextField("Description", text: $viewModel.content, axis: .vertical)
                    .lineLimit(4...8)

                if viewModel.initialType == .task {
                    DatePicker("Deadline", selection: $viewModel.deadline)
                }
            }

            Section("Attachments") {
                Button("Attach files") {
                    isImporterPresented = true
                }
                .disabled(viewModel.isLoading)

                if viewModel.selectedFileURLs.isEmpty {
                    Text("No files attached")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.selectedFileURLs, id: \.self) { url in
                        Text(url.lastPathComponent)
                    }
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            }
        }
        .navigationTitle(viewModel.initialType == .task ? "Create Task" : "Create Material")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(viewModel.initialType == .task ? "Create" : "Post") {
                    Task {
                        let success = await viewModel.createTapped()
                        if success {
                            dismiss()
                        }
                    }
                }
                .disabled(!viewModel.canCreate)
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.data, .content, .item, .image, .audio],
            allowsMultipleSelection: true
        ) { result in
            if case let .success(urls) = result {
                viewModel.selectedFileURLs = urls
            }
        }
    }
}
