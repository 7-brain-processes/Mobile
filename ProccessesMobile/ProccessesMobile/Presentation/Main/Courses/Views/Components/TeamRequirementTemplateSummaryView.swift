//
//  TeamRequirementTemplateSummaryView.swift
//  ProccessesMobile
//
//  Created by Codex on 20.05.2026.
//

import SwiftUI

struct TeamRequirementTemplateSummaryView: View {
    let template: TeamRequirementTemplate

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(template.name)
                .font(.subheadline)
                .fontWeight(.semibold)

            if let description = template.description,
               !description.isEmpty {
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            ForEach(constraintLines, id: \.self) { line in
                Text(line)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var constraintLines: [String] {
        var lines: [String] = []

        if let minTeamSize = template.minTeamSize {
            lines.append("Min team size: \(minTeamSize)")
        }

        if let maxTeamSize = template.maxTeamSize {
            lines.append("Max team size: \(maxTeamSize)")
        }

        if let requiredCategory = template.requiredCategory {
            lines.append("Required category: \(requiredCategory.title)")
        }

        if template.requireAudio {
            lines.append("Audio submission required")
        }

        if template.requireVideo {
            lines.append("Video submission required")
        }

        if lines.isEmpty {
            lines.append("No additional restrictions")
        }

        return lines
    }
}
