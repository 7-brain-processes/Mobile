//
//  UpdateCourseCategoryRequestMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum UpdateCourseCategoryRequestMapper {
    static func toDTO(_ domain: UpdateCourseCategoryRequest) -> UpdateCourseCategoryRequestDTO {
        UpdateCourseCategoryRequestDTO(
            title: domain.title,
            description: domain.description,
            active: domain.isActive
        )
    }
}