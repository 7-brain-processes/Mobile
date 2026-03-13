//
//  JoinByCodeView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import SwiftUI

struct JoinByCodeView: View {
    @StateObject private var viewModel: JoinByCodeViewModel

    init(viewModel: JoinByCodeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Join Course")
                    .font(.title)
                    .bold()
                    .accessibilityIdentifier(AccessibilityID.JoinCourse.title)

                TextField("Course code", text: $viewModel.code)
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.isLoading)
                    .accessibilityIdentifier(AccessibilityID.JoinCourse.codeField)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Button(viewModel.isLoading ? "Joining..." : "Join") {
                    viewModel.joinTapped()
                }
                .disabled(viewModel.isLoading)
                .accessibilityIdentifier(AccessibilityID.JoinCourse.joinButton)

                Button("Cancel") {
                    viewModel.cancelTapped()
                }
                .disabled(viewModel.isLoading)
                .accessibilityIdentifier(AccessibilityID.JoinCourse.cancelButton)
            }
            .padding()
            .navigationTitle("Join Course")
        }
    }
}
