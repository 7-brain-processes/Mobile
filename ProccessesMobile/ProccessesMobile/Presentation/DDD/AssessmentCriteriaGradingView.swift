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
                    publishSection
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

    private var publishSection: some View {
        Section("Publication") {
            if viewModel.selectedAssessmentResult?.published == true {
                Label("Published for students", systemImage: "checkmark.seal.fill")
                    .foregroundStyle(.green)
            } else {
                Text("Saved grades are not visible to students until published.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Button {
                    Task {
                        await viewModel.publishCriteriaGrades()
                    }
                } label: {
                    if viewModel.isPublishingCriteriaGrades {
                        ProgressView()
                    } else {
                        Label("Publish result", systemImage: "paperplane.fill")
                    }
                }
                .disabled(viewModel.selectedAssessmentResult == nil || viewModel.isPublishingCriteriaGrades)
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
        CriterionGradeNumberField(
            title: title,
            value: value,
            onValidNumber: onChange
        )
    }

    private func scoreText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...2)))
    }
}

private struct CriterionGradeNumberField: View {
    let title: String
    let value: Double?
    let onValidNumber: (Double) -> Void

    @State private var text: String

    init(
        title: String,
        value: Double?,
        onValidNumber: @escaping (Double) -> Void
    ) {
        self.title = title
        self.value = value
        self.onValidNumber = onValidNumber
        _text = State(initialValue: value.map { $0.formatted(.number.precision(.fractionLength(0...2))) } ?? "")
    }

    var body: some View {
        TextField(
            title,
            text: Binding(
                get: { text },
                set: { input in
                    text = input

                    guard !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        return
                    }

                    if let parsed = Double(input.replacingOccurrences(of: ",", with: ".")) {
                        onValidNumber(parsed)
                    }
                }
            )
        )
        .keyboardType(.decimalPad)
    }
}
