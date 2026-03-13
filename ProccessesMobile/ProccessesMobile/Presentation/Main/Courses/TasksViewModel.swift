import Combine
import Foundation

@MainActor
final class TasksViewModel: ObservableObject {
    private let courseId: UUID
    private weak var navigator: FeedScreenNavigating?

    let role: CourseRole
    @Published var tasks: [FeedPostItem]

    init(
        courseId: UUID,
        role: CourseRole,
        navigator: FeedScreenNavigating?,
        tasks: [FeedPostItem] = FeedViewModel.mockPosts.filter { $0.type == .task }
    ) {
        self.courseId = courseId
        self.role = role
        self.navigator = navigator
        self.tasks = tasks
    }

    var canCreateTask: Bool {
        role == .teacher
    }

    var isEmpty: Bool {
        tasks.isEmpty
    }

    func createTaskTapped() {
        guard role == .teacher else { return }
        navigator?.openCreatePost(courseId: courseId, type: .task)
    }

    func taskTapped(_ task: FeedPostItem) {
        navigator?.openTaskDetail(courseId: courseId, postId: task.id)
    }
}
