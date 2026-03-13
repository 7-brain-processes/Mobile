struct DownloadSolutionFileQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let fileId: UUID
}
