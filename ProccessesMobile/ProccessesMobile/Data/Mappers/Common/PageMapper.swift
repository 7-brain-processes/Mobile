//
//  PageMapper.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

enum PageMapper {
    static func map<DTO, Domain>(
        _ dto: PageDTO<DTO>,
        itemMapper: (DTO) throws -> Domain
    ) rethrows -> Page<Domain>
    where DTO: Codable & Equatable & Sendable, Domain: Equatable & Sendable {
        Page(
            content: try dto.content.map(itemMapper),
            page: dto.page,
            size: dto.size,
            totalElements: dto.totalElements,
            totalPages: dto.totalPages
        )
    }
}

extension PageDTO {
    func toDomain<U>(_ map: (T) throws -> U) rethrows -> Page<U> {
        Page(
            content: try content.map(map),
            page: page,
            size: size,
            totalElements: totalElements,
            totalPages: totalPages
        )
    }
}
