//
//  DateParser.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

enum DateParser {
    static func parse(_ string: String) -> Date? {
        APIFormatters.iso8601WithFractionalSeconds.date(from: string)
        ?? APIFormatters.iso8601.date(from: string)
    }
}
