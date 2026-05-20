//
//  TeamEnrollmentStatus.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//



import Foundation

struct TeamEnrollmentStatus: Equatable, Sendable {
    let teamId: UUID
    let teamName: String
    let teamGrade: Int?
    let currentMembers: Int
    let maxSize: Int?
}
