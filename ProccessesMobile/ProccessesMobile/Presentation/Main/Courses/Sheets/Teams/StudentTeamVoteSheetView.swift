//
//  StudentTeamVoteSheetView.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import SwiftUI

struct StudentTeamVoteSheetView: View {
    let teamName: String
    let teamGrade: Int?
    let members: [User]
    let voteStatus: TeamGradeVoteStatus?
    let isSubmitting: Bool
    let errorMessage: String?
    let onSubmit: ([StudentGradeVoteEntry]) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var draftGrades: [UUID: String]

    init(
        teamName: String,
        teamGrade: Int?,
        members: [User],
        voteStatus: TeamGradeVoteStatus?,
        isSubmitting: Bool,
        errorMessage: String?,
        onSubmit: @escaping ([StudentGradeVoteEntry]) -> Void
    ) {
        self.teamName = teamName
        self.teamGrade = teamGrade
        self.members = members
        self.voteStatus = voteStatus
        self.isSubmitting = isSubmitting
        self.errorMessage = errorMessage
        self.onSubmit = onSubmit
        _draftGrades = State(initialValue: Self.makeInitialDraft(members: members, teamGrade: teamGrade, voteStatus: voteStatus))
    }

    private static func makeInitialDraft(
        members: [User],
        teamGrade: Int?,
        voteStatus: TeamGradeVoteStatus?
    ) -> [UUID: String] {
        if let voteStatus, !voteStatus.myVote.isEmpty {
            return Dictionary(
                uniqueKeysWithValues: voteStatus.myVote.map { ($0.student.id, $0.grade.map(String.init) ?? "") }
            )
        }

        guard let teamGrade, !members.isEmpty else {
            return Dictionary(uniqueKeysWithValues: members.map { ($0.id, "") })
        }

        let base = teamGrade / members.count
        let remainder = teamGrade % members.count

        return Dictionary(uniqueKeysWithValues: members.enumerated().map { index, user in
            let grade = base + (index < remainder ? 1 : 0)
            return (user.id, String(grade))
        })
    }

    private var normalizedBindings: [UUID: Binding<String>] {
        Dictionary(uniqueKeysWithValues: members.map { member in
            (
                member.id,
                Binding(
                    get: { draftGrades[member.id, default: ""] },
                    set: { draftGrades[member.id] = String($0.filter(\.isNumber).prefix(3)) }
                )
            )
        })
    }

    private var parsedEntries: [StudentGradeVoteEntry]? {
        var entries: [StudentGradeVoteEntry] = []

        for member in members {
            guard let value = draftGrades[member.id], let grade = Int(value) else {
                return nil
            }

            guard (0...100).contains(grade) else {
                return nil
            }

            entries.append(StudentGradeVoteEntry(studentId: member.id, grade: grade))
        }

        return entries
    }

    private var assignedTotal: Int {
        draftGrades.values.compactMap(Int.init).reduce(0, +)
    }

    private var isTotalValid: Bool {
        guard let teamGrade else { return false }
        return assignedTotal == teamGrade
    }

    private var canSubmit: Bool {
        guard let voteStatus else { return false }
        return voteStatus.canSubmitVote && parsedEntries != nil && isTotalValid && !isSubmitting
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Voting") {
                    LabeledContent("Team", value: teamName)
                    LabeledContent("Status", value: voteStatus?.state.title ?? "Not started")
                    LabeledContent("Team grade", value: teamGrade.map { "\($0)/100" } ?? "Not graded")

                    if let voteStatus {
                        LabeledContent("Votes", value: "\(voteStatus.votedCount)/\(voteStatus.voters.count)")
                    }
                }

                if let voteStatus, !voteStatus.myVote.isEmpty {
                    Section("Your vote") {
                        ForEach(voteStatus.myVote, id: \.student.id) { item in
                            LabeledContent(
                                item.student.displayName,
                                value: item.grade.map { "\($0)/100" } ?? "Not graded"
                            )
                        }
                    }
                } else {
                    Section("Your distribution") {
                        ForEach(members, id: \.id) { member in
                            TextField(
                                member.displayName,
                                text: normalizedBindings[member.id] ?? .constant("")
                            )
                            .keyboardType(.numberPad)
                        }

                        if let teamGrade {
                            if isTotalValid {
                                LabeledContent("Assigned total", value: "\(assignedTotal)/\(teamGrade)")
                                    .foregroundStyle(.secondary)
                            } else {
                                LabeledContent("Assigned total", value: "\(assignedTotal)/\(teamGrade)")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }

                if let voteStatus {
                    Section("Team votes") {
                        ForEach(voteStatus.voters, id: \.user.id) { voter in
                            LabeledContent(
                                voter.user.displayName,
                                value: voter.hasVoted ? "Voted" : "Pending"
                            )
                        }
                    }
                }

                if let voteStatus, voteStatus.finalized, !voteStatus.finalDistribution.isEmpty {
                    Section("Final distribution") {
                        ForEach(voteStatus.finalDistribution, id: \.student.id) { item in
                            LabeledContent(
                                item.student.displayName,
                                value: item.grade.map { "\($0)/100" } ?? "Not graded"
                            )
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
            .navigationTitle("Voting")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    if let parsedEntries, voteStatus?.myVote.isEmpty == true {
                        Button {
                            onSubmit(parsedEntries)
                        } label: {
                            if isSubmitting {
                                ProgressView()
                            } else {
                                Text("Submit")
                            }
                        }
                        .disabled(!canSubmit)
                    }
                }
            }
        }
    }
}
