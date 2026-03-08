//
//  CourseEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseEndpoint {

    case getCourses(page: Int, size: Int, role: CourseRoleDTO?, baseURL: URL)
    case create(request: CreateCourseRequestDTO, baseURL: URL)

    func makeURLRequest() throws -> URLRequest {

        switch self {

        case let .getCourses(page, size, role, baseURL):

            var components = URLComponents(
                url: baseURL.appendingPathComponent("/courses"),
                resolvingAgainstBaseURL: false
            )!

            var queryItems = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]

            if let role {
                queryItems.append(
                    URLQueryItem(name: "role", value: role.rawValue)
                )
            }

            components.queryItems = queryItems

            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"

            return request


        case let .create(dto, baseURL):

            let url = baseURL.appendingPathComponent("/courses")

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)

            return request
        }
    }
}
