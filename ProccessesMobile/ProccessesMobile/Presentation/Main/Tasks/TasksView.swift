//
//  TasksView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI

struct TasksView: View {
    @StateObject private var viewModel: TasksViewModel

    init(viewModel: TasksViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if viewModel.isLoading && viewModel.tasks.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemGroupedBackground))
                } else if let errorMessage = viewModel.errorMessage, viewModel.tasks.isEmpty {
                    VStack(spacing: 12) {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)

                        Button("Retry") {
                            viewModel.refresh()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGroupedBackground))
                } else if viewModel.isEmpty {
                    ContentUnavailableView(
                        "No tasks yet",
                        systemImage: "checklist",
                        description: Text(
                            viewModel.canCreateTask
                            ? "Create the first task for this course."
                            : "Tasks will appear here when the teacher adds them."
                        )
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(viewModel.tasks) { task in
                                Button {
                                    viewModel.taskTapped(task)
                                } label: {
                                    HStack(alignment: .top, spacing: 12) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.orange.opacity(0.12))
                                            .frame(width: 44, height: 44)
                                            .overlay {
                                                Image(systemName: "checklist")
                                                    .foregroundStyle(.orange)
                                            }

                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(task.title)
                                                .font(.headline)
                                                .foregroundStyle(.primary)

                                            Text(task.contentPreview)
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
                                                .lineLimit(2)

                                            if let deadline = task.deadline {
                                                Text("Due \(deadline.formatted(date: .abbreviated, time: .omitted))")
                                                    .font(.caption)
                                                    .foregroundStyle(.secondary)
                                            }
                                        }

                                        Spacer()

                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.tertiary)
                                    }
                                    .padding(16)
                                    .background(Color(.systemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(16)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }

            if viewModel.canCreateTask {
                Button {
                    viewModel.createTaskTapped()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 8, y: 4)
                }
                .padding(20)
            }
        }
        .navigationTitle("Tasks")
        .task {
            viewModel.onAppear()
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}
