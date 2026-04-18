//
//  CreateCourseCategoryRequestDTO.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

struct CreateCourseCategoryRequestDTO: Encodable {
    let title: String
    let description: String
    let active: Bool
}