//
//  CoursesSideMenuView.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import SwiftUI


struct CoursesSideMenuView: View {
    let currentUserInitial: String
    let currentUserDisplayName: String
    let teachingCourses: [CourseCardItem]
    let attendingCourses: [CourseCardItem]
    let onCourseTap: (UUID) -> Void
    let onLogout: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: 20)
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 44, height: 44)

                        Text(currentUserInitial)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .accessibilityIdentifier(AccessibilityID.Courses.sideMenuUserAvatar)

                    Text(currentUserDisplayName)
                        .font(.headline)
                        .accessibilityIdentifier(AccessibilityID.Courses.sideMenuUserName)

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 28)
                .padding(.bottom, 20)

                Divider()
                    .padding(.bottom, 12)

                if !teachingCourses.isEmpty {
                    menuSection(
                        title: "Teaching",
                        identifier: AccessibilityID.Courses.sideMenuTeachingSection,
                        courses: teachingCourses
                    )
                }

                if !attendingCourses.isEmpty {
                    menuSection(
                        title: "Attending",
                        identifier: AccessibilityID.Courses.sideMenuAttendingSection,
                        courses: attendingCourses
                    )
                }

                Divider()
                    .padding(.top, 12)

                Button(action: onLogout) {
                    HStack(spacing: 12) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                        Spacer()
                    }
                    .font(.headline)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .accessibilityIdentifier(AccessibilityID.Courses.sideMenuLogoutButton)
            }
        }
        .frame(maxWidth: 350, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.18), radius: 16, x: 4, y: 0)
        .accessibilityIdentifier(AccessibilityID.Courses.sideMenu)
    }

    @ViewBuilder
    private func menuSection(
        title: String,
        identifier: String,
        courses: [CourseCardItem]
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 6)
                .accessibilityIdentifier(identifier)

            ForEach(courses) { course in
                Button {
                    onCourseTap(course.id)
                } label: {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(CourseCardColor.color(for: course.id))
                                .frame(width: 32, height: 32)

                            Text(course.initial)
                                .font(.subheadline)
                                .foregroundStyle(.white)
                        }

                        Text(course.name)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .accessibilityIdentifier(AccessibilityID.Courses.sideMenuCourse(course.id))
            }
        }
    }
}
