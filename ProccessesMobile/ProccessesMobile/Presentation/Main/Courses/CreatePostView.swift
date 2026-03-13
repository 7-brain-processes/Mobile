//
//  CreatePostView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI
import UniformTypeIdentifiers

struct CreatePostView: View {
    let initialType: FeedPostType

    @Environment(\.dismiss) private var dismiss

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var deadline: Date = .now
    @State private var selectedFileURLs: [URL] = []
    @State private var isImporterPresented = false

    init(initialType: FeedPostType) {
        self.initialType = initialType
    }

    private var canCreate: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section("Content") {
                TextField("Title", text: $title)

                TextField("Description", text: $content, axis: .vertical)
                    .lineLimit(4...8)

                if initialType == .task {
                    DatePicker("Deadline", selection: $deadline)
                }
            }

            Section("Attachments") {
                Button("Attach files") {
                    isImporterPresented = true
                }

                if selectedFileURLs.isEmpty {
                    Text("No files attached")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(selectedFileURLs, id: \.self) { url in
                        Text(url.lastPathComponent)
                    }
                }
            }
        }
        .navigationTitle(initialType == .task ? "Create Task" : "Create Material")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(initialType == .task ? "Create" : "Post") {
                    dismiss()
                }
                .disabled(!canCreate)
            }
        }
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.data, .content, .item, .image, .audio],
            allowsMultipleSelection: true
        ) { result in
            if case let .success(urls) = result {
                selectedFileURLs = urls
            }
        }
    }
}
