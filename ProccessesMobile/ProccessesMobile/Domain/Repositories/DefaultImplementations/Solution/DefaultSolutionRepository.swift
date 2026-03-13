//
//  DefaultSolutionRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultSolutionRepository: SolutionRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    private func decodeResponse<T: Decodable>(
        data: Data,
        response: HTTPURLResponse,
        successCodes: Set<Int>
    ) throws -> T {
        try ResponseValidator.validate(response, successCodes: successCodes)
        return try decoder.decode(T.self, from: data)
    }

    func listSolutions(_ query: ListSolutionsQuery) async throws -> Page<Solution> {
        let endpoint = SolutionEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            page: query.page,
            size: query.size,
            status: query.status.map(SolutionStatusMapper.toDTO)
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: PageDTO<SolutionDTO> = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try PageMapper.toDomain(
            dto,
            itemMapper: SolutionMapper.toDomain
        )
    }

    func submitSolution(_ command: SubmitSolutionCommand) async throws -> Solution {
        let endpoint = SolutionEndpoint.submit(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: SubmitSolutionMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: SolutionDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [201]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func getMySolution(_ command: GetMySolutionQuery) async throws -> Solution {
        let endpoint = SolutionEndpoint.getMy(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: SolutionDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func getSolution(_ command: SolutionOfPost) async throws -> Solution {
        let endpoint = SolutionEndpoint.get(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: SolutionDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func updateSolution(_ command: UpdateSolutionCommand) async throws -> Solution {
        let endpoint = SolutionEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: UpdateSolutionMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        let dto: SolutionDTO = try decodeResponse(
            data: data,
            response: response,
            successCodes: [200]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func deleteSolution(_ command: SolutionOfPost) async throws {
        let endpoint = SolutionEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
