//
//  PostTeamsRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

protocol PostTeamsRepository: Sendable {
    func listTeamsForEnrollment(_ query: ListTeamsForEnrollmentQuery) async throws -> [CourseTeamAvailability]
    func getMyTeam(_ query: GetMyTeamInPostQuery) async throws -> StudentTeam
    func enroll(_ command: EnrollStudentInTeamCommand) async throws -> EnrollmentResponse
    func leave(_ command: LeaveTeamCommand) async throws -> EnrollmentResponse
}

struct DefaultPostTeamsRepository: PostTeamsRepository, Sendable {
    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listTeamsForEnrollment(_ query: ListTeamsForEnrollmentQuery) async throws -> [CourseTeamAvailability] {
        let endpoint = PostTeamsEndpoint.listForEnrollment(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode([CourseTeamAvailabilityDTO].self, from: data)

        return try dto.map(CourseTeamAvailabilityMapper.toDomain)
    }

    func getMyTeam(_ query: GetMyTeamInPostQuery) async throws -> StudentTeam {
        let endpoint = PostTeamsEndpoint.getMyTeam(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(StudentTeamDTO.self, from: data)

        return try StudentTeamMapper.toDomain(dto)
    }

    func enroll(_ command: EnrollStudentInTeamCommand) async throws -> EnrollmentResponse {
        let endpoint = PostTeamsEndpoint.enroll(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            teamId: command.teamId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(EnrollmentResponseDTO.self, from: data)

        return try EnrollmentResponseMapper.toDomain(dto)
    }

    func leave(_ command: LeaveTeamCommand) async throws -> EnrollmentResponse {
        let endpoint = PostTeamsEndpoint.leave(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            teamId: command.teamId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(EnrollmentResponseDTO.self, from: data)

        return try EnrollmentResponseMapper.toDomain(dto)
    }
}