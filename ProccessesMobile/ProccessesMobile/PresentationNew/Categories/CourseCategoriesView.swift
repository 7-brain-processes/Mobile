//
//  CourseCategoriesView.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//

import SwiftUI

struct CourseCategoriesView: View {
    @StateObject private var viewModel: CourseCategoriesViewModel

    init(viewModel: @autoclosure @escaping () -> CourseCategoriesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
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
                }
                .padding()
            } else if viewModel.categories.isEmpty {
                Text("Категорий курса пока нет")
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
        .task {
            await viewModel.load()
        }
    }
}
