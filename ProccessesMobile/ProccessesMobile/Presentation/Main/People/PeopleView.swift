//
//  PeopleView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI


struct PeopleView: View {
    @StateObject private var viewModel: PeopleViewModel

    init(viewModel: PeopleViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }

            sectionView(title: "Teachers", people: viewModel.teachers) {
                viewModel.addTeacherTapped()
            }

            sectionView(title: "Students", people: viewModel.students) {
                viewModel.addStudentTapped()
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.teachers.isEmpty && viewModel.students.isEmpty {
                ProgressView()
            }
        }
        .sheet(isPresented: $viewModel.isInviteSheetPresented) {
            InviteCodeSheetView(
                role: viewModel.inviteTargetRole,
                maxUses: $viewModel.inviteMaxUses,
                durationDays: $viewModel.inviteDurationDays,
                generatedCode: viewModel.generatedInviteCode,
                onGenerate: {
                    viewModel.generateInviteCode()
                }
            )
        }
        .navigationTitle("People")
        .task {
            viewModel.onAppear()
        }
        .refreshable {
            viewModel.refresh()
        }
    }

    @ViewBuilder
    private func sectionView(
        title: String,
        people: [CoursePersonItem],
        onAdd: @escaping () -> Void
    ) -> some View {
        Section {
            if people.isEmpty {
                Text("No \(title.lowercased())")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(people) { person in
                    HStack(spacing: 12) {
                        InitialAvatarView(
                            name: person.name,
                            size: 40,
                            backgroundColor: .blue
                        )

                        Text(person.name)

                        Spacer()

                        Menu {
                            if viewModel.canManagePeople {
                                Button(role: .destructive) {
                                    viewModel.kick(person)
                                } label: {
                                    Label("Kick", systemImage: "person.fill.xmark")
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundStyle(.secondary)
                                .frame(width: 32, height: 32)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        } header: {
            HStack {
                Text(title)

                Spacer()

                if viewModel.canManagePeople {
                    Button(action: onAdd) {
                        Image(systemName: "person.badge.plus")
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
