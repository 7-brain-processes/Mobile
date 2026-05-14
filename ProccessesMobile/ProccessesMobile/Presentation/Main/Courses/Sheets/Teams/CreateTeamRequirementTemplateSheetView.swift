//
//  CreateTeamRequirementTemplateSheetView.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import SwiftUI

struct CreateTeamRequirementTemplateSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CreateTeamRequirementTemplateSheetViewModel

    init(viewModel: @autoclosure @escaping () -> CreateTeamRequirementTemplateSheetViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Основное") {
                    TextField("Название", text: $viewModel.name)

                    TextField("Описание", text: $viewModel.description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Размер команды") {
                    TextField("Минимум", text: $viewModel.minTeamSize)
                        .keyboardType(.numberPad)

                    TextField("Максимум", text: $viewModel.maxTeamSize)
                        .keyboardType(.numberPad)
                }

                Section("Категория") {
                    if viewModel.isLoadingCategories {
                        ProgressView()
                    } else {
                        Picker("Категория", selection: $viewModel.selectedCategoryId) {
                            Text("Любая")
                                .tag(UUID?.none)

                            ForEach(viewModel.categories, id: \.id) { category in
                                Text(category.title)
                                    .tag(Optional(category.id))
                            }
                        }
                    }
                }

                Section("Требования") {
                    Toggle("Требуется аудио", isOn: $viewModel.requireAudio)
                    Toggle("Требуется видео", isOn: $viewModel.requireVideo)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Новый шаблон")
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
                        Button("Создать") {
                            Task {
                                await viewModel.submit()
                            }
                        }
                        .disabled(!viewModel.canSubmit)
                    }
                }
            }
            .task {
                await viewModel.onAppear()
            }
        }
    }
}