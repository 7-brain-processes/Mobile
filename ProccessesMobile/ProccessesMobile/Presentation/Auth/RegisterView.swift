//
//  RegisterView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel: RegisterViewModel

    init(viewModel: RegisterViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            VStack(spacing: 12) {
                Text("Register")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityIdentifier(AccessibilityID.Register.title)

                Text("Create your account")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                TextField("Displayed name", text: $viewModel.displayedName)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier(AccessibilityID.Register.displayedNameField)

                TextField("Login", text: $viewModel.login)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier(AccessibilityID.Register.loginField)

                SecureField("Password", text: $viewModel.password)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier(AccessibilityID.Register.passwordField)
            }

            VStack(spacing: 12) {
                Button {
                    viewModel.simulateRegisterSuccessTapped()
                } label: {
                    Text("Simulate Register + Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier(AccessibilityID.Register.simulateRegisterButton)

                Button {
                    viewModel.backTapped()
                } label: {
                    Text("Back")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier(AccessibilityID.Register.backButton)
            }

            Spacer()
        }
        .padding(20)
        .navigationTitle("Register")
    }
}
