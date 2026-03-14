//
//  ListPostMaterialsQuery.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 08.03.2026.
//

import Foundation

struct ListPostMaterialsQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
}
