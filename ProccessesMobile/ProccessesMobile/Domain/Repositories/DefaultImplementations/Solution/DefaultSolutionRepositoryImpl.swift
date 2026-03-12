//
//  DefaultSolutionRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultSolutionRepositoryImpl: SolutionRepository {
    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private func handleResponse<T: Decodable>(
        data: Data,
        response: HTTPURLResponse,
        successCodes: [Int]
    ) throws -> T {
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        if response.statusCode == 409 { throw APIError.serverError(code: 409) }

        guard successCodes.contains(response.statusCode) else {
            throw APIError.serverError(code: response.statusCode)
        }

        return try decoder.decode(T.self, from: data)
    }

    func listSolutions(_ query: ListSolutionsQuery) async throws -> Page<Solution> {
        let req = try SolutionEndpoint.list(
            courseId: query.courseId.uuidString,
            postId: query.postId.uuidString,
            page: query.page,
            size: query.size,
            status: query.status.map(SolutionStatusMapper.toDTO),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: PageDTO<SolutionDTO> = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try PageMapper.toDomain(
            dto,
            itemMapper: SolutionMapper.toDomain
        )
    }

    func submitSolution(_ command: SubmitSolutionCommand) async throws -> Solution {
        let req = try SolutionEndpoint.submit(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            request: SubmitSolutionMapper.toDTO(command),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: SolutionDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [201]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func getMySolution(_ command: GetMySolutionQuery) async throws -> Solution {
        let req = try SolutionEndpoint.getMy(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: SolutionDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func getSolution(_ command: SolutionOfPost) async throws -> Solution {
        let req = try SolutionEndpoint.get(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: SolutionDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func updateSolution(_ command: UpdateSolutionCommand) async throws -> Solution {
        let req = try SolutionEndpoint.update(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: UpdateSolutionMapper.toDTO(command),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        let dto: SolutionDTO = try handleResponse(
            data: data,
            response: res,
            successCodes: [200]
        )

        return try SolutionMapper.toDomain(dto)
    }

    func deleteSolution(_ command: SolutionOfPost) async throws {
        let req = try SolutionEndpoint.delete(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            baseURL: baseURL
        ).makeURLRequest()

        let (_, res) = try await client.send(req)

        if res.statusCode == 200 || res.statusCode == 204 {
            return
        }

        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        throw APIError.serverError(code: res.statusCode)
    }
}
