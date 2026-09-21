import Combine

@MainActor
final class RootViewModel: ObservableObject {
    enum Tab: Hashable {
        case discover
        case favorites
        case cart
        case orders
    }

    @Published var selectedTab: Tab = .discover
}
