//
//  EditCourseCategorySheetView.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import SwiftUI

struct EditCourseCategorySheetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EditCourseCategorySheetViewModel

    init(viewModel: @autoclosure @escaping () -> EditCourseCategorySheetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название", text: $viewModel.title)

                    TextField("Описание", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)

                    Toggle("Активна", isOn: $viewModel.isActive)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .disabled(viewModel.isSubmitting)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.isSubmitting {
                        ProgressView()
                    } else {
                        Button("Сохранить") {
                            Task {
                                await viewModel.save()
                            }
                        }
                        .disabled(viewModel.isSaveDisabled)
                    }
                }
            }
        }
    }
}