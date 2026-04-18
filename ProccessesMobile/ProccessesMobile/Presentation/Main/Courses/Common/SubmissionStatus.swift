//
//  SubmissionStatus.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//


enum SubmissionStatus: Equatable {
    case draft
    case submitted
    case rejected
    case accepted

    var title: String {
        switch self {
        case .draft: return "Draft"
        case .submitted: return "Submitted"
        case .rejected: return "Needs changes"
        case .accepted: return "Accepted"
        }
    }
}