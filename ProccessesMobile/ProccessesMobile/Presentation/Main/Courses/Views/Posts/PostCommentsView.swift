//
//  PostCommentsView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI

struct PostCommentsView: View {
    let title: String

    var body: some View {
        List {
            Section {
                Text("Comments will appear here.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle(title)
    }
}