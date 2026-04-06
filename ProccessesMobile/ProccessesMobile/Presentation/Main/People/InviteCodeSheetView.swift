//
//  InviteCodeSheetView.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


import SwiftUI

struct InviteCodeSheetView: View {
    let role: CourseRole
    @Binding var maxUses: Int
    @Binding var durationDays: Int
    let generatedCode: String?
    let onGenerate: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Invite settings") {
                    Stepper("Max people: \(maxUses)", value: $maxUses, in: 1...100)
                    Stepper("Duration: \(durationDays) day(s)", value: $durationDays, in: 1...30)
                }

                Section {
                    Button("Generate code") {
                        onGenerate()
                    }
                }

                if let generatedCode {
                    Section("Invite code") {
                        HStack {
                            Text(generatedCode)
                                .font(.headline.monospaced())

                            Spacer()

                            Button("Copy") {
                                UIPasteboard.general.string = generatedCode
                            }
                        }
                    }
                }
            }
            .navigationTitle(role == .teacher ? "Invite Teacher" : "Invite Student")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
