import SwiftUI

@MainActor
protocol AuthViewBuilding {
    func makeLoginView(coordinator: AuthCoordinator) -> AnyView
    func makeRegisterView(coordinator: AuthCoordinator) -> AnyView
}
