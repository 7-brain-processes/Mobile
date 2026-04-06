//
//  APIFormatters.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

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

func parseDate(_ value: String) throws -> Date {
    if let date =
        APIFormatters.iso8601WithFractionalSeconds.date(from: value) ??
        APIFormatters.iso8601.date(from: value) {
        return date
    }

    throw APIError.invalidResponse
}

func formatDate(_ date: Date) -> String {
    APIFormatters.iso8601WithFractionalSeconds.string(from: date)
}
