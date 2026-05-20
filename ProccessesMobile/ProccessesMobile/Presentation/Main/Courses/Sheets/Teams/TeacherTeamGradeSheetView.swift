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
    let errorMessage: String?
    let onSave: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var gradeInput: String

    init(
        team: CourseTeamAvailability,
        isSaving: Bool,
        errorMessage: String?,
        onSave: @escaping (String) -> Void
    ) {
        self.team = team
        self.isSaving = isSaving
        self.errorMessage = errorMessage
        self.onSave = onSave
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
