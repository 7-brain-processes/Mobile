//
//  AssessmentCriteriaGradingView.swift
//  ProccessesMobile
//

import SwiftUI

struct AssessmentCriteriaGradingView: View {
    @ObservedObject var viewModel: TaskDetailViewModel
    let submission: TaskSubmissionItem

    var body: some View {
        NavigationStack {
            Form {
                if let config = viewModel.assessmentConfig {
                    resultSection
                    criteriaSection(config)
                    errorSection
                } else {
                    Section {
                        ContentUnavailableView(
                            "Assessment config is not configured",
                            systemImage: "slider.horizontal.3",
                            description: Text("Create a grading configuration before assessing this submission by criteria.")
                        )
                    }
                    errorSection
                }
            }
            .navigationTitle("Criteria grading")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        viewModel.closeCriteriaGrading()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task {
                            await viewModel.saveCriteriaGrades()
                        }
                    } label: {
                        if viewModel.isSavingCriteriaGrades {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(viewModel.assessmentConfig == nil || viewModel.isSavingCriteriaGrades)
                }
            }
            .overlay {
                if viewModel.isLoadingCriteriaGrades {
                    ProgressView()
                        .padding(24)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }

    private var resultSection: some View {
        Section("Result") {
            LabeledContent("Student", value: submission.studentName)

            if let basicScore = viewModel.selectedAssessmentResult?.basicScore {
                LabeledContent("Basic score", value: scoreText(basicScore))
            }

            if let modifierDelta = viewModel.selectedAssessmentResult?.modifierDelta {
                LabeledContent("Modifier delta", value: scoreText(modifierDelta))
            }

            if let finalScore = viewModel.selectedAssessmentResult?.finalScore {
                LabeledContent("Final score", value: scoreText(finalScore))
            }

            if let result = viewModel.selectedAssessmentResult {
                LabeledContent("Published", value: result.published ? "Yes" : "No")
            }
        }
    }

    private func criteriaSection(_ config: AssessmentConfig) -> some View {
        Section("Criteria") {
            if config.criteria.isEmpty {
                Text("No criteria configured")
                    .foregroundStyle(.secondary)
            }

            ForEach(Array(config.criteria.enumerated()), id: \.offset) { _, criterion in
                CriterionGradeEditorRow(
                    criterion: criterion,
                    grade: viewModel.criteriaGradeDraft(for: criterion.id),
                    onValueChange: { value in
                        viewModel.updateCriteriaGradeValueDraft(
                            criterionId: criterion.id,
                            value: value
                        )
                    },
                    onCommentChange: { comment in
                        viewModel.updateCriteriaGradeCommentDraft(
                            criterionId: criterion.id,
                            comment: comment
                        )
                    }
                )
            }
        }
    }

    @ViewBuilder
    private var errorSection: some View {
        if let message = viewModel.assessmentErrorMessage {
            Section {
                Text(message)
                    .foregroundStyle(.red)
            }
        }
    }

    private func scoreText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...2)))
    }
}

private struct CriterionGradeEditorRow: View {
    let criterion: AssessmentCriterion
    let grade: CriterionGrade?
    let onValueChange: (Double) -> Void
    let onCommentChange: (String?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(criterion.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Text("\(criterion.type.displayName), max \(scoreText(criterion.maxPoints)), weight \(scoreText(criterion.weight))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            valueInput

            TextField(
                "Comment",
                text: Binding(
                    get: { grade?.comment ?? "" },
                    set: { value in
                        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
                        onCommentChange(trimmed.isEmpty ? nil : value)
                    }
                ),
                axis: .vertical
            )
            .lineLimit(2...5)
        }
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private var valueInput: some View {
        switch criterion.type {
        case .yesNo:
            Picker(
                "Value",
                selection: Binding(
                    get: { grade?.value ?? 0 },
                    set: onValueChange
                )
            ) {
                Text("No").tag(0.0)
                Text("Yes").tag(1.0)
            }
            .pickerStyle(.segmented)

        case .percentage:
            numericField(
                title: "Percent, 0...100",
                value: grade?.value,
                onChange: onValueChange
            )

        case .points:
            numericField(
                title: "Points, max \(scoreText(criterion.maxPoints))",
                value: grade?.value,
                onChange: onValueChange
            )

        case .unknown:
            numericField(
                title: "Value",
                value: grade?.value,
                onChange: onValueChange
            )
        }
    }

    private func numericField(
        title: String,
        value: Double?,
        onChange: @escaping (Double) -> Void
    ) -> some View {
        TextField(
            title,
            text: Binding(
                get: { value.map(scoreText) ?? "" },
                set: { input in
                    if let parsed = Double(input.replacingOccurrences(of: ",", with: ".")) {
                        onChange(parsed)
                    }
                }
            )
        )
        .keyboardType(.decimalPad)
    }

    private func scoreText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...2)))
    }
}
