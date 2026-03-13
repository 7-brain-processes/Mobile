struct RemoveGradeCommand: Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
}