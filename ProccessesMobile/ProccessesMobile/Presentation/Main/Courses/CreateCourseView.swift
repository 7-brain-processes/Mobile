//
//  CreateCourseView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import SwiftUI

struct CreateCourseView: View {
    @StateObject private var viewModel: CreateCourseViewModel

    init(viewModel: CreateCourseViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Create Course")
                    .font(.title)
                    .bold()
                    .accessibilityIdentifier(AccessibilityID.CreateCourse.title)

                TextField("Course name", text: $viewModel.courseName)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isLoading)
                    .accessibilityIdentifier(AccessibilityID.CreateCourse.nameField)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Button(viewModel.isLoading ? "Creating..." : "Finish") {
                    viewModel.finishTapped()
                }
                .disabled(viewModel.isLoading)
                .accessibilityIdentifier(AccessibilityID.CreateCourse.finishButton)

                Button("Cancel") {
                    viewModel.cancelTapped()
                }
                .disabled(viewModel.isLoading)
                .accessibilityIdentifier(AccessibilityID.CreateCourse.cancelButton)
            }
            .padding()
            .navigationTitle("Create Course")
        }
    }
}
