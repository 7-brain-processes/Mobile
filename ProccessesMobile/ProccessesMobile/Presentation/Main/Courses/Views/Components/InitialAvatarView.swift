//
//  InitialAvatarView.swift
//  ProccessesMobile
//
//  Created by dark type on 12.03.2026.
//


import SwiftUI

struct InitialAvatarView: View {
    let name: String
    var size: CGFloat = 40
    var backgroundColor: Color = .blue

    private var initial: String {
        String(name.trimmingCharacters(in: .whitespacesAndNewlines).prefix(1)).uppercased()
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)

            Text(initial)
                .font(.system(size: size * 0.42, weight: .semibold))
                .foregroundStyle(.white)
        }
    }
}