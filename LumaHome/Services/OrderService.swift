import Combine
import Foundation

@MainActor
final class OrderService: ObservableObject {
    @Published private(set) var orders: [Order]

    private let userDefaults: UserDefaults
    private let storageKey = "lumahome.orders.v1"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        if
            let data = userDefaults.data(forKey: storageKey),
            let saved = try? JSONDecoder().decode([Order].self, from: data)
        {
            orders = saved
        } else {
            orders = []
        }
    }

    @discardableResult
    func placeOrder(items: [CartItem], total: Decimal) -> Order? {
        guard !items.isEmpty else { return nil }

        let order = Order(items: items, total: total)
        orders.insert(order, at: 0)
        save()
        return order
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(orders) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
