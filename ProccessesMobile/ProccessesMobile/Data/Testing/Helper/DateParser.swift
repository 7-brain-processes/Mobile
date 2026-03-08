//
//  DateParser.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

private let apiDateFormatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
}()

func parseDate(_ value: String) throws -> Date {
    if let date = apiDateFormatter.date(from: value) {
        return date
    }
    throw APIError.invalidResponse
}

func formatDate(_ date: Date) -> String {
    apiDateFormatter.string(from: date)
}

enum DateParser {
    static func parse(_ string: String) -> Date? {
        APIFormatters.iso8601WithFractionalSeconds.date(from: string)
        ?? APIFormatters.iso8601.date(from: string)
    }
}
