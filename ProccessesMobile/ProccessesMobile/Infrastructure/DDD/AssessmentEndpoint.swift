//
//  AssessmentEndpoint.swift
//  ProccessesMobile
//

import Foundation

enum AssessmentEndpoint: Endpoint {
    case getGradingConfig(courseId: String, postId: String)
    case upsertGradingConfig(courseId: String, postId: String, request: Encodable)
    case deleteGradingConfig(courseId: String, postId: String)
    case getCriteriaGrades(courseId: String, postId: String, solutionId: String)
    case updateCriteriaGrades(courseId: String, postId: String, solutionId: String, request: Encodable)
    case publishCriteriaGrades(courseId: String, postId: String, solutionId: String)
    case getMyGradeDecomposition(courseId: String, postId: String)

    var path: String {
        switch self {
        case .getGradingConfig(let courseId, let postId),
             .upsertGradingConfig(let courseId, let postId, _),
             .deleteGradingConfig(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/grading-config"

        case .getCriteriaGrades(let courseId, let postId, let solutionId),
             .updateCriteriaGrades(let courseId, let postId, let solutionId, _):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/criteria-grades"

        case .publishCriteriaGrades(let courseId, let postId, let solutionId):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/criteria-grades/publish"

        case .getMyGradeDecomposition(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/solutions/my/grade-decomposition"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getGradingConfig, .getCriteriaGrades, .getMyGradeDecomposition:
            return .GET
        case .upsertGradingConfig, .updateCriteriaGrades:
            return .PUT
        case .deleteGradingConfig:
            return .DELETE
        case .publishCriteriaGrades:
            return .POST
        }
    }

    var headers: [String: String] {
        [
            "Accept": "application/json"
        ]
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var body: EndpointBody {
        switch self {
        case .upsertGradingConfig(_, _, let request),
             .updateCriteriaGrades(_, _, _, let request):
            return .json(request)
        case .getGradingConfig,
             .deleteGradingConfig,
             .getCriteriaGrades,
             .publishCriteriaGrades,
             .getMyGradeDecomposition:
            return .none
        }
    }

    var requiresAuth: Bool {
        true
    }
}
