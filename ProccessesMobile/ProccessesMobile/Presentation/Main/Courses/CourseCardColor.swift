//
//  CourseCardColor.swift
//  ProccessesMobile
//
//  Created by dark type on 09.03.2026.
//

import SwiftUI

enum CourseCardColor {
    static func color(for id: UUID) -> Color {
        let colors: [Color] = [
            Color(red: 25.0 / 255.0, green: 103.0 / 255.0, blue: 210.0 / 255.0),
            Color(red: 24.0 / 255.0, green: 143.0 / 255.0, blue: 88.0 / 255.0),
            Color(red: 66.0 / 255.0, green: 133.0 / 255.0, blue: 244.0 / 255.0),
            Color(red: 124.0 / 255.0, green: 58.0 / 255.0, blue: 237.0 / 255.0),
            Color(red: 227.0 / 255.0, green: 116.0 / 255.0, blue: 0.0 / 255.0),
            Color(red: 11.0 / 255.0, green: 128.0 / 255.0, blue: 67.0 / 255.0)
        ]

        var hash: Int = 0

        for scalar in id.uuidString.unicodeScalars {
            hash = Int(scalar.value) &+ ((hash &<< 5) &- hash)
        }

        let index = Int(hash.magnitude % UInt(colors.count))
        return colors[index]
    }
}
