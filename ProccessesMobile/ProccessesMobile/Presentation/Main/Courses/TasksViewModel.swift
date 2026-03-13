import Combine
import Foundation

@MainActor
final class TasksViewModel: ObservableObject {
    private let courseId: UUID
    private let listPostsUseCase: ListPostsUseCase
    private weak var navigator: FeedScreenNavigating?

    let role: CourseRole

    @Published var tasks: [FeedPostItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(
        courseId: UUID,
        role: CourseRole,
        listPostsUseCase: ListPostsUseCase,
        navigator: FeedScreenNavigating?
    ) {
        self.courseId = courseId
        self.role = role
        self.listPostsUseCase = listPostsUseCase
        self.navigator = navigator
    }

    var canCreateTask: Bool {
        role == .teacher
    }

    var isEmpty: Bool {
        tasks.isEmpty
    }

    func onAppear() {
        guard tasks.isEmpty, !isLoading else { return }
        loadTasks()
    }

    func refresh() {
        loadTasks()
    }

    func createTaskTapped() {
        guard role == .teacher else { return }
        navigator?.openCreatePost(courseId: courseId, type: .task)
    }

    func taskTapped(_ task: FeedPostItem) {
        navigator?.openTaskDetail(courseId: courseId, postId: task.id)
    }

    private func loadTasks() {
        Task {
            isLoading = true
            errorMessage = nil

            defer { isLoading = false }

            do {
                let page = try await listPostsUseCase.execute(
                    ListPostsQuery(
                        courseId: courseId,
                        page: 0,
                        size: 20,
                        type: .task
                    )
                )

                tasks = page.content.map(Self.mapToTaskItem)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private static func mapToTaskItem(_ post: Post) -> FeedPostItem {
        FeedPostItem(
            id: post.id,
            type: .task,
            title: post.title,
            contentPreview: post.content ?? "",
            createdAt: post.createdAt,
            deadline: post.deadline,
            author: FeedAuthorItem(
                displayName: post.author.displayName!
            ),
            attachments: [],
            commentsCount: post.commentsCount,
            solutionsCount: post.solutionsCount,
            mySolutionId: post.mySolutionId
        )
    }
}
