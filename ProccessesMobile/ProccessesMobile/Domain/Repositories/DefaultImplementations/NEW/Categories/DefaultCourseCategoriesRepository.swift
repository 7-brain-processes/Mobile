//
//  DefaultCourseCategoriesRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

final class DefaultCourseCategoriesRepository: CourseCategoriesRepository, Sendable {
    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func listCourseCategories(courseId: UUID) async throws -> [CourseCategory] {
        let endpoint = CourseCategoriesEndpoint.list(courseId: courseId)
        let (data, response) = try await apiClient.send(endpoint)

        switch response.statusCode {
        case 200:
            let dto = try decoder.decode([CourseCategoryDTO].self, from: data)
            return try dto.map(CourseCategoryMapper.toDomain)

        case 403:
            throw AppError.forbidden

        case 404:
            throw AppError.notFound

        default:
            throw AppError.serverError(statusCode: response.statusCode)
        }
    }

    func createCourseCategory(
        courseId: UUID,
        request: CreateCourseCategoryRequest
    ) async throws -> CourseCategory {
        let requestDTO = CreateCourseCategoryRequestMapper.toDTO(request)
        let endpoint = CourseCategoriesEndpoint.create(
            courseId: courseId,
            request: requestDTO
        )

        let (data, response) = try await apiClient.send(endpoint)

        switch response.statusCode {
        case 201:
            let dto = try decoder.decode(CourseCategoryDTO.self, from: data)
            return try CourseCategoryMapper.toDomain(dto)

        case 403:
            throw AppError.forbidden

        case 404:
            throw AppError.notFound

        default:
            throw AppError.serverError(statusCode: response.statusCode)
        }
    }
}
