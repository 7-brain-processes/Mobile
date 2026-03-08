//
//  APIFormatters.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

//enum DateParser {
//    static func parse(_ string: String) -> Date? {
//        APIFormatters.iso8601WithFractionalSeconds.date(from: string)
//        ?? APIFormatters.iso8601.date(from: string)
//    }
//}

enum APIFormatters {
    static let iso8601WithFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
