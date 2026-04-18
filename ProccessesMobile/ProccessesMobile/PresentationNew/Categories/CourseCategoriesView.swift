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

    init(
        viewModel: @autoclosure @escaping () -> CourseCategoriesViewModel,
        createViewBuilder: @escaping () -> AnyView
    ) {
        _viewModel = StateObject(wrappedValue: viewModel())
        self.createViewBuilder = createViewBuilder
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
                        Task {
                            await viewModel.load()
                        }
                    }
                }
                .padding()
            } else if viewModel.categories.isEmpty {
                VStack(spacing: 16) {
                    Text("Категорий курса пока нет")

                    Button("Создать категорию") {
                        viewModel.openCreateSheet()
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                List(viewModel.categories, id: \.id) { category in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(category.title)
                                .font(.headline)

                            if !category.isActive {
                                Text("inactive")
                                    .font(.caption)
                            }
                        }

                        if !category.description.isEmpty {
                            Text(category.description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .sheet(isPresented: $viewModel.isCreateSheetPresented) {
            createViewBuilder()
        }
        .task {
            await viewModel.load()
        }
    }
}
