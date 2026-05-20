//
//  CourseCategoriesEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum CourseCategoriesEndpoint: Endpoint {
    case list(courseId: UUID)
    case create(courseId: UUID, request: CreateCourseCategoryRequestDTO)
    case update(courseId: UUID, categoryId: UUID, request: UpdateCourseCategoryRequestDTO)
    case delete(courseId: UUID, categoryId: UUID)
    case getMyCategory(courseId: UUID)
    case setMyCategory(courseId: UUID, request: SetMyCourseCategoryRequestDTO)

    var path: String {
        switch self {
        case .list(let courseId),
             .create(let courseId, _):
            return "courses/\(courseId.uuidString)/categories"

        case .update(let courseId, let categoryId, _),
             .delete(let courseId, let categoryId):
            return "courses/\(courseId.uuidString)/categories/\(categoryId.uuidString)"

        case .getMyCategory(let courseId),
             .setMyCategory(let courseId, _):
            return "courses/\(courseId.uuidString)/members/me/category"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .GET
        case .create:
            return .POST
        case .update:
            return .PUT
        case .delete:
            return .DELETE
        case .getMyCategory:
            return .GET
        case .setMyCategory:
            return .PUT
        }
    }

    var headers: [String : String] {
        ["Accept": "application/json"]
    }

    var body: EndpointBody {
        switch self {
        case .list, .delete:
            return .none
        case .create(_, let request):
            return .json(request)
        case .update(_, _, let request):
            return .json(request)
        case .getMyCategory:
            return .none
        case .setMyCategory(_, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool { true }
}
