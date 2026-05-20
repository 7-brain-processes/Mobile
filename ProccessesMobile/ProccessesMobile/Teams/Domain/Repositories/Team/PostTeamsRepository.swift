//
//  PostTeamsRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

protocol PostTeamsRepository: Sendable {
    func listTeamsForEnrollment(_ query: ListTeamsForEnrollmentQuery) async throws -> [CourseTeamAvailability]
    func create(_ command: CreatePostTeamCommand) async throws -> CourseTeamAvailability
    func updateGrade(_ command: UpdateTeamGradeCommand) async throws -> TeamGrade
    func getMyTeam(_ query: GetMyTeamInPostQuery) async throws -> StudentTeam
    func enroll(_ command: EnrollStudentInTeamCommand) async throws -> EnrollmentResponse
    func leave(_ command: LeaveTeamCommand) async throws -> EnrollmentResponse
    func getGrade(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGrade
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

    func getGrade(courseId: UUID, postId: UUID, teamId: UUID) async throws -> TeamGrade {
        let endpoint = PostTeamsEndpoint.getGrade(
            courseId: courseId.uuidString,
            postId: postId.uuidString,
            teamId: teamId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(TeamGradeDTO.self, from: data)
        return try TeamGradeMapper.toDomain(dto)
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

    func create(_ command: CreatePostTeamCommand) async throws -> CourseTeamAvailability {
        let endpoint = PostTeamsEndpoint.create(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: CreatePostTeamMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 201])

        let dto = try decoder.decode(CourseTeamAvailabilityDTO.self, from: data)

        return try CourseTeamAvailabilityMapper.toDomain(dto)
    }

    func updateGrade(_ command: UpdateTeamGradeCommand) async throws -> TeamGrade {
        let endpoint = PostTeamsEndpoint.grade(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            teamId: command.teamId.uuidString,
            request: TeamGradeMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(TeamGradeDTO.self, from: data)

        return try TeamGradeMapper.toDomain(dto)
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
