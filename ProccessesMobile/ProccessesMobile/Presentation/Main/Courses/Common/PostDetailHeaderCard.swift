//
//  PostDetailHeaderCard.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI

struct PostDetailHeaderCard: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let author: String
    let createdAt: Date
    let deadline: Date?
    let description: String
    let titleIdentifier: String
    let authorIdentifier: String
    let dateIdentifier: String
    let deadlineIdentifier: String?
    let descriptionIdentifier: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(iconColor)
                        .frame(width: 44, height: 44)

                    Image(systemName: iconName)
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .semibold))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .accessibilityIdentifier(titleIdentifier)

                    HStack(spacing: 6) {
                        Text(author)
                            .accessibilityIdentifier(authorIdentifier)
                        Text("•")
                        Text(createdAt.formatted(date: .abbreviated, time: .omitted))
                            .accessibilityIdentifier(dateIdentifier)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(20)

            if let deadline {
                HStack {
                    Label(
                        "Due: \(deadline.formatted(date: .abbreviated, time: .shortened))",
                        systemImage: "calendar"
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier(deadlineIdentifier ?? "")
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }

            Divider()

            Text(description)
                .font(.body)
                .foregroundStyle(.primary)
                .padding(20)
                .accessibilityIdentifier(descriptionIdentifier)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}
