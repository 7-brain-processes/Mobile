//
//  CourseCategoriesView.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//

import SwiftUI

struct CourseCategoriesView: View {
    @StateObject private var viewModel: CourseCategoriesViewModel
    private let createViewBuilder: () -> AnyView
    private let editViewBuilder: (CourseCategory) -> AnyView
    private let role: CourseRole

    init(
        viewModel: @autoclosure @escaping () -> CourseCategoriesViewModel,
        role: CourseRole,
        createViewBuilder: @escaping () -> AnyView,
        editViewBuilder: @escaping (CourseCategory) -> AnyView
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.role = role
        self.createViewBuilder = createViewBuilder
        self.editViewBuilder = editViewBuilder
    }
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Ошибка")
                        .font(.headline)

                    Text(errorMessage)
                        .multilineTextAlignment(.center)

                    Button("Повторить") {
                        Task { await viewModel.load() }
                    }
                }
                .padding()
            } else if viewModel.categories.isEmpty {
                VStack(spacing: 16) {
                    Text("Категорий курса пока нет")

                    if role == .teacher {
                        Button("Создать категорию") {
                            viewModel.openCreateSheet()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else {
                List {
                    if role == .teacher {
                        Button {
                            viewModel.openCreateSheet()
                        } label: {
                            Label("Create a category", systemImage: "plus")
                        }
                    }

                    if role == .student && viewModel.selectedCategoryId != nil {
                        Button {
                            Task {
                                await viewModel.clearSelection()
                            }
                        } label: {
                            Label("Сбросить выбор", systemImage: "xmark.circle")
                        }
                        .disabled(viewModel.isSelectionUpdating)
                    }

                    ForEach(viewModel.categories, id: \.id) { category in
                        HStack(spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    Text(category.title)
                                        .font(.headline)

                                    if !category.isActive {
                                        Text("inactive")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }

                                if !category.description.isEmpty {
                                    Text(category.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Spacer()

                            if role == .student {
                                if viewModel.isSelectionUpdating &&
                                    viewModel.selectedCategoryId == category.id {
                                    ProgressView()
                                } else {
                                    Image(
                                        systemName: viewModel.selectedCategoryId == category.id
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                    )
                                    .foregroundStyle(
                                        viewModel.selectedCategoryId == category.id
                                        ? .blue
                                        : .secondary
                                    )
                                }
                            }
                        }
                        .padding(.vertical, 4)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            switch role {
                            case .teacher:
                                viewModel.openEditSheet(category: category)

                            case .student:
                                guard category.isActive else { return }
                                Task {
                                    await viewModel.selectCategory(category)
                                }
                            }
                        }
                        .swipeActions {
                            if role == .teacher {
                                Button(role: .destructive) {
                                    Task {
                                        await viewModel.delete(category: category)
                                    }
                                } label: {
                                    Label("Удалить", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isCreateSheetPresented) {
            if role == .teacher {
                createViewBuilder()
            }
        }
        .sheet(item: $viewModel.editingCategory) { category in
            if role == .teacher {
                editViewBuilder(category)
            }
        }
        .task {
            await viewModel.load()
        }
    }
}
