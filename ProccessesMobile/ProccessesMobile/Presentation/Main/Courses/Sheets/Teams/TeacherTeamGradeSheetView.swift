//
//  TeacherTeamGradeSheetView.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import SwiftUI

struct TeacherTeamGradeSheetView: View {
    let team: CourseTeamAvailability
    let isSaving: Bool
    let distribution: TeamGradeDistribution?
    let voteStatus: TeamGradeVoteStatus?
    let isLoadingDistribution: Bool
    let isLoadingVoteStatus: Bool
    let isApplyingAutoDistribution: Bool
    let isFinalizingVote: Bool
    let errorMessage: String?
    let onSave: (String) -> Void
    let onApplyAutoEqualDistribution: () -> Void
    let onApplyVotingDistribution: () -> Void
    let onFinalizeVoting: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var gradeInput: String

    init(
        team: CourseTeamAvailability,
        isSaving: Bool,
        distribution: TeamGradeDistribution?,
        voteStatus: TeamGradeVoteStatus?,
        isLoadingDistribution: Bool,
        isLoadingVoteStatus: Bool,
        isApplyingAutoDistribution: Bool,
        isFinalizingVote: Bool,
        errorMessage: String?,
        onSave: @escaping (String) -> Void,
        onApplyAutoEqualDistribution: @escaping () -> Void,
        onApplyVotingDistribution: @escaping () -> Void,
        onFinalizeVoting: @escaping () -> Void
    ) {
        self.team = team
        self.isSaving = isSaving
        self.distribution = distribution
        self.voteStatus = voteStatus
        self.isLoadingDistribution = isLoadingDistribution
        self.isLoadingVoteStatus = isLoadingVoteStatus
        self.isApplyingAutoDistribution = isApplyingAutoDistribution
        self.isFinalizingVote = isFinalizingVote
        self.errorMessage = errorMessage
        self.onSave = onSave
        self.onApplyAutoEqualDistribution = onApplyAutoEqualDistribution
        self.onApplyVotingDistribution = onApplyVotingDistribution
        self.onFinalizeVoting = onFinalizeVoting
        _gradeInput = State(initialValue: team.teamGrade.map(String.init) ?? "")
    }

    private var normalizedGradeBinding: Binding<String> {
        Binding(
            get: { gradeInput },
            set: { newValue in
                gradeInput = String(newValue.filter(\.isNumber).prefix(3))
            }
        )
    }

    private var parsedGrade: Int? {
        Int(gradeInput)
    }

    private var isGradeValid: Bool {
        guard let parsedGrade else { return false }
        return (0...100).contains(parsedGrade)
    }

    private var canSave: Bool {
        isGradeValid && !isSaving
    }

    private var canApplyAutoEqualDistribution: Bool {
        team.teamGrade != nil && !isApplyingAutoDistribution && !isLoadingDistribution
    }

    private var canApplyVotingDistribution: Bool {
        team.teamGrade != nil && !isApplyingAutoDistribution && !isLoadingDistribution
    }

    private var canFinalizeVoting: Bool {
        guard let voteStatus else { return false }
        return !voteStatus.finalized && !isFinalizingVote
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Team") {
                    LabeledContent("Name", value: team.name)
                    LabeledContent(
                        "Members",
                        value: "\(team.currentMembers)/\(team.maxSize.map(String.init) ?? "∞")"
                    )
                    LabeledContent(
                        "Current grade",
                        value: team.teamGrade.map { "\($0)/100" } ?? "Not graded"
                    )
                }

                Section("Grade") {
                    TextField("0...100", text: normalizedGradeBinding)
                        .keyboardType(.numberPad)

                    if !gradeInput.isEmpty && !isGradeValid {
                        Text("Grade must be between 0 and 100")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }

                Section("Distribution") {
                    if isLoadingDistribution {
                        ProgressView("Loading distribution...")
                    } else {
                        LabeledContent(
                            "Mode",
                            value: distribution?.distributionMode.title ?? "Manual"
                        )

                        Button {
                            onApplyAutoEqualDistribution()
                        } label: {
                            if isApplyingAutoDistribution {
                                ProgressView()
                            } else {
                                Text("Apply AUTO_EQUAL")
                            }
                        }
                        .disabled(!canApplyAutoEqualDistribution)

                        Button("Enable voting") {
                            onApplyVotingDistribution()
                        }
                        .disabled(!canApplyVotingDistribution)

                        if let distribution, distribution.students.isEmpty {
                            Text("Individual grades are not assigned yet")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        if let distribution {
                            ForEach(distribution.students, id: \.student.id) { item in
                                LabeledContent(
                                    item.student.displayName,
                                    value: item.grade.map { "\($0)/100" } ?? "Not graded"
                                )
                            }
                        }
                    }
                }

                if distribution?.distributionMode == .teamVote {
                    Section("Voting status") {
                        if isLoadingVoteStatus {
                            ProgressView("Loading voting status...")
                        } else if let voteStatus {
                            LabeledContent("Status", value: voteStatus.state.title)
                            LabeledContent("Votes", value: "\(voteStatus.votedCount)/\(voteStatus.voters.count)")

                            ForEach(voteStatus.voters, id: \.user.id) { voter in
                                LabeledContent(
                                    voter.user.displayName,
                                    value: voter.hasVoted ? "Voted" : "Pending"
                                )
                            }

                            Button {
                                onFinalizeVoting()
                            } label: {
                                if isFinalizingVote {
                                    ProgressView()
                                } else {
                                    Text("Finalize voting")
                                }
                            }
                            .disabled(!canFinalizeVoting)

                            if voteStatus.finalized, !voteStatus.finalDistribution.isEmpty {
                                ForEach(voteStatus.finalDistribution, id: \.student.id) { item in
                                    LabeledContent(
                                        item.student.displayName,
                                        value: item.grade.map { "\($0)/100" } ?? "Not graded"
                                    )
                                }
                            }
                        } else {
                            Text("Voting has not started yet")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                if let errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle(team.teamGrade == nil ? "Set team grade" : "Edit team grade")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        onSave(gradeInput)
                    } label: {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text(team.teamGrade == nil ? "Set" : "Save")
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}
