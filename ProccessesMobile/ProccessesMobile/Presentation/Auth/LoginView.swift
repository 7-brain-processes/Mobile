//
//  LoginView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import SwiftUI


struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 40)

            VStack(spacing: 12) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityIdentifier(AccessibilityID.Login.title)

                Text("Sign in to continue")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 16) {
                TextField("Login", text: $viewModel.login)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier(AccessibilityID.Login.loginField)

                SecureField("Password", text: $viewModel.password)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .accessibilityIdentifier(AccessibilityID.Login.passwordField)
            }

            VStack(spacing: 12) {
                Button {
                    viewModel.simulateLoginTapped()
                } label: {
                    Text("Simulate Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier(AccessibilityID.Login.simulateLoginButton)

                Button {
                    viewModel.registerTapped()
                } label: {
                    Text("Go to Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .foregroundStyle(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier(AccessibilityID.Login.registerButton)
            }

            Spacer()
        }
        .padding(20)
        .navigationTitle("Login")
    }
}
