//
//  DownloadSolutionFileQuery.swift
//  ProccessesMobile
//
//  Created by dark type on 13.03.2026.
//

import Foundation

struct DownloadSolutionFileQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let fileId: UUID
}
