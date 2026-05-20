//
//  CourseCardView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI

struct CourseCardView: View {
    let course: CourseCardItem
    let onTap: () -> Void

    private var headerColor: Color {
        CourseCardColor.color(for: course.id)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topLeading) {
                headerColor
                    .frame(height: 120)

                LinearGradient(
                    colors: [
                        Color.white.opacity(0.10),
                        Color.white.opacity(0.02)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(height: 120)

                VStack(alignment: .leading, spacing: 8) {
                    Text(course.name)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .accessibilityIdentifier(AccessibilityID.Courses.courseTitle(course.id))

                    Text(course.description)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.92))
                        .lineLimit(1)

                    Spacer()

                    Text(course.participantsText)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.22))
                                .frame(width: 64, height: 64)

                            Text(course.initial)
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundStyle(.white)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 16)
                    }
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.03), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.10), radius: 8, x: 0, y: 3)
        .contentShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture(perform: onTap)
    }
}
