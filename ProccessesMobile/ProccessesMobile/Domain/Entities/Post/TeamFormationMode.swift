//
//  TeamFormationMode.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


enum TeamFormationMode: Equatable, Sendable, Codable {
    case free
    case draft
    case randomShuffle
    case captainSelection
}

extension TeamFormationMode: CaseIterable, Identifiable {
    var id: Self { self }

    var title: String {
        switch self {
        case .free:
            return "Free"
        case .draft:
            return "Draft"
        case .randomShuffle:
            return "Random shuffle"
        case .captainSelection:
            return "Captain selection"
        }
    }
}
