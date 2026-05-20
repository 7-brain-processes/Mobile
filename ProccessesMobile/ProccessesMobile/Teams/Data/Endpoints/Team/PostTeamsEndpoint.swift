//
//  PostTeamsEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum PostTeamsEndpoint: Endpoint {
    case listForEnrollment(courseId: String, postId: String)
    case create(courseId: String, postId: String, request: CreatePostTeamRequestDTO)
    case grade(courseId: String, postId: String, teamId: String, request: TeamGradeRequestDTO)
    case getGradeDistribution(courseId: String, postId: String, teamId: String)
    case updateGradeDistribution(
        courseId: String,
        postId: String,
        teamId: String,
        request: UpdateTeamGradeDistributionRequestDTO
    )
    case getMyTeam(courseId: String, postId: String)
    case getStudentVoteStatus(courseId: String, postId: String)
    case submitVote(courseId: String, postId: String, request: CaptainGradeDistributionRequestDTO)
    case getTeacherVoteStatus(courseId: String, postId: String, teamId: String)
    case finalizeVote(courseId: String, postId: String, teamId: String)
    case enroll(courseId: String, postId: String, teamId: String)
    case leave(courseId: String, postId: String, teamId: String)
    case getGrade(courseId: String, postId: String, teamId: String)

    var path: String {
        switch self {
        case .listForEnrollment(let courseId, let postId),
             .create(let courseId, let postId, _):
            return "courses/\(courseId)/posts/\(postId)/teams"

        case .getMyTeam(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/my-team"

        case .getStudentVoteStatus(let courseId, let postId),
             .submitVote(let courseId, let postId, _):
            return "courses/\(courseId)/posts/\(postId)/grade-vote"

        case .grade(let courseId, let postId, let teamId, _),
             .getGrade(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/grade"

        case .getGradeDistribution(let courseId, let postId, let teamId),
             .updateGradeDistribution(let courseId, let postId, let teamId, _):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/grade/distribution"

        case .getTeacherVoteStatus(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/grade-vote"

        case .finalizeVote(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/grade-vote/finalize"

        case .enroll(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/enroll"

        case .leave(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/leave"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listForEnrollment, .getMyTeam, .getGrade, .getGradeDistribution,
             .getStudentVoteStatus, .getTeacherVoteStatus:
            return .GET
        case .create, .enroll, .submitVote, .finalizeVote:
            return .POST
        case .grade, .updateGradeDistribution:
            return .PUT
        case .leave:
            return .DELETE
        }
    }

    var headers: [String: String] {
        ["Accept": "application/json"]
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var body: EndpointBody {
        switch self {
        case .listForEnrollment, .getMyTeam, .enroll, .leave, .getGrade,
             .getGradeDistribution, .getStudentVoteStatus, .getTeacherVoteStatus, .finalizeVote:
            return .none
        case .create(_, _, let request):
            return .json(request)
        case .grade(_, _, _, let request):
            return .json(request)
        case .updateGradeDistribution(_, _, _, let request):
            return .json(request)
        case .submitVote(_, _, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
