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
                    .accessibilityIdentifier(AccessibilityID.JoinCourse.codeField)

                Button("Join") {
                    viewModel.joinTapped()
                }
                .accessibilityIdentifier(AccessibilityID.JoinCourse.joinButton)

                Button("Cancel") {
                    viewModel.cancelTapped()
                }
                .accessibilityIdentifier(AccessibilityID.JoinCourse.cancelButton)
            }
            .padding()
            .navigationTitle("Join Course")
        }
    }
}
