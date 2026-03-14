//
//  ListPostsQuery.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct ListPostsQuery: Equatable, Sendable {
    let courseId: UUID
    let page: Int
    let size: Int
    let type: PostType?
}
