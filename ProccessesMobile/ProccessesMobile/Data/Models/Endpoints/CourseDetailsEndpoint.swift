//
//  CourseDetailsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseDetailsEndpoint {

    case get(courseId: String, baseURL: URL)
    case update(courseId: String, request: UpdateCourseRequestDTO, baseURL: URL)
    case delete(courseId: String, baseURL: URL)

    func makeURLRequest() throws -> URLRequest {

        switch self {

        case let .get(courseId, baseURL):

            let url = baseURL.appendingPathComponent("/courses/\(courseId)")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request


        case let .update(courseId, dto, baseURL):

            let url = baseURL.appendingPathComponent("/courses/\(courseId)")

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            request.httpBody = try JSONEncoder().encode(dto)

            return request


        case let .delete(courseId, baseURL):

            let url = baseURL.appendingPathComponent("/courses/\(courseId)")

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"

            return request
        }
    }
}
