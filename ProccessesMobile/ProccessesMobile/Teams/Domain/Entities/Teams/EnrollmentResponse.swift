//
//  EnrollmentResponse.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

struct EnrollmentResponse: Equatable, Sendable {
    let success: Bool
    let message: String
    let team: TeamEnrollmentStatus?
}
