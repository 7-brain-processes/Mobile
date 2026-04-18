//
//  UpdateCourseCategoryRequest.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

struct UpdateCourseCategoryRequest: Equatable, Sendable {
    let title: String
    let description: String
    let isActive: Bool
}