//
//  CourseCategoriesServiceProtocol.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

protocol CourseCategoriesServiceProtocol: Sendable {
    func listCourseCategories(courseId: UUID) async throws -> [CourseCategoryDTO]
}

final class CourseCategoriesService: CourseCategoriesServiceProtocol, Sendable {
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

    func listCourseCategories(courseId: UUID) async throws -> [CourseCategoryDTO] {
        let endpoint = CourseCategoriesEndpoint.list(courseId: courseId)
        let (data, response) = try await apiClient.send(endpoint)

        switch response.statusCode {
        case 200:
            do {
                return try decoder.decode([CourseCategoryDTO].self, from: data)
            } catch {
                throw CourseCategoriesServiceError.decodingFailed
            }

        case 403:
            throw CourseCategoriesServiceError.forbidden

        case 404:
            throw CourseCategoriesServiceError.notFound

        default:
            throw CourseCategoriesServiceError.unexpectedStatus(response.statusCode)
        }
    }
}