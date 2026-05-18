//
//  CreateCourseCategoryRequestMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum CreateCourseCategoryRequestMapper {
    static func toDTO(_ domain: CreateCourseCategoryRequest) -> CreateCourseCategoryRequestDTO {
        CreateCourseCategoryRequestDTO(
            title: domain.title,
            description: domain.description,
            active: domain.isActive
        )
    }
}