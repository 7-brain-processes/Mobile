//
//  SetMyCourseCategoryRequestMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 04.05.2026.
//


import Foundation

enum SetMyCourseCategoryRequestMapper {
    static func toDTO(_ domain: SetMyCourseCategoryRequest) -> SetMyCourseCategoryRequestDTO {
        SetMyCourseCategoryRequestDTO(
            categoryId: domain.categoryId?.uuidString
        )
    }
}