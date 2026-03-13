//
//  CourseActionsSheet.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//


import SwiftUI


struct CourseActionsSheet: View {
    let onCreateCourse: () -> Void
    let onJoinCourse: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color(.systemGray4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Actions")
                .font(.headline)
                .foregroundStyle(.secondary)

            Button(action: onCreateCourse) {
                HStack(spacing: 12) {
                    Image(systemName: "plus.circle.fill")
                    Text("Create course")
                    Spacer()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .accessibilityIdentifier(AccessibilityID.Courses.createCourseButton)

            Button(action: onJoinCourse) {
                HStack(spacing: 12) {
                    Image(systemName: "qrcode.viewfinder")
                    Text("Join course")
                    Spacer()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .accessibilityIdentifier(AccessibilityID.Courses.joinCourseButton)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.systemBackground))
    }
}
