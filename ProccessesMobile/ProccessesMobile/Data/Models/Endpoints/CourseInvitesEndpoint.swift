//
//  CourseInvitesEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public enum CourseInvitesEndpoint {
    case list(courseId: String, baseURL: URL)
    case create(courseId: String, request: CreateInviteRequest, baseURL: URL)
    case revoke(courseId: String, inviteId: String, baseURL: URL)
    
    public func makeURLRequest() throws -> URLRequest {
        let basePath = "/courses"
        switch self {
        case let .list(courseId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/invites"))
            request.httpMethod = "GET"
            return request
            
        case let .create(courseId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/invites"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .revoke(courseId, inviteId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/invites/\(inviteId)"))
            request.httpMethod = "DELETE"
            return request
        }
    }
}
