//
//  StudentGradeBreakdownView.swift
//  ProccessesMobile
//

import SwiftUI

struct StudentGradeBreakdownView: View {
    let breakdown: GradeBreakdown
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Grade breakdown")
                    .font(.headline)

                Spacer()

                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }

            scoreSummary

            if !breakdown.criteria.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Criteria")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    ForEach(Array(breakdown.criteria.enumerated()), id: \.offset) { _, item in
                        criterionRow(item)
                    }
                }
            }

            if !breakdown.modifiers.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Modifiers")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    ForEach(Array(breakdown.modifiers.enumerated()), id: \.offset) { _, item in
                        modifierRow(item)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var scoreSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let finalScore = breakdown.finalScore {
                LabeledContent("Final score", value: scoreText(finalScore))
                    .font(.headline)
            }

            if let basicScore = breakdown.basicScore {
                LabeledContent("Basic score", value: scoreText(basicScore))
            }

            if let modifierDelta = breakdown.modifierDelta {
                LabeledContent("Modifier delta", value: signedScoreText(modifierDelta))
            }
        }
        .font(.subheadline)
    }

    private func criterionRow(_ item: CriterionBreakdownItem) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text(item.type.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if let score = item.score {
                    Text(scoreText(score))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }

            if let value = item.value {
                Text("Value: \(scoreText(value))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let comment = item.comment,
               !comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(comment)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func modifierRow(_ item: ModifierBreakdownItem) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                Spacer()

                if let effect = item.effect {
                    Text(signedScoreText(effect))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }

            Text(item.type.displayName)
                .font(.caption)
                .foregroundStyle(.secondary)

            if let value = item.value {
                Text("Value: \(scoreText(value))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let description = item.description,
               !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func scoreText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...2)))
    }

    private func signedScoreText(_ value: Double) -> String {
        let prefix = value > 0 ? "+" : ""
        return prefix + scoreText(value)
    }
}
