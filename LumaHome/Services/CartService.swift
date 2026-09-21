import Combine
import Foundation

@MainActor
final class CartService: ObservableObject {
    @Published private(set) var items: [CartItem]

    private let userDefaults: UserDefaults
    private let storageKey = "lumahome.bag.items.v1"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        if
            let data = userDefaults.data(forKey: storageKey),
            let saved = try? JSONDecoder().decode([CartItem].self, from: data)
        {
            items = saved
        } else {
            items = []
        }
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    var subtotal: Decimal {
        items.reduce(Decimal(0)) { $0 + $1.lineTotal }
    }

    var deliveryFee: Decimal {
        subtotal >= Decimal(1000) || items.isEmpty ? Decimal(0) : Decimal(35)
    }

    var total: Decimal {
        subtotal + deliveryFee
    }

    func add(
        product: Product,
        color: ProductColor,
        quantity: Int
    ) {
        let quantityToAdd = max(1, quantity)

        if let index = items.firstIndex(where: {
            $0.product.id == product.id && $0.selectedColor == color
        }) {
            items[index].quantity += quantityToAdd
        } else {
            items.append(
                CartItem(
                    product: product,
                    selectedColor: color,
                    quantity: quantityToAdd
                )
            )
        }

        save()
    }

    func increment(_ item: CartItem) {
        updateQuantity(for: item.id, to: item.quantity + 1)
    }

    func decrement(_ item: CartItem) {
        if item.quantity <= 1 {
            remove(item)
        } else {
            updateQuantity(for: item.id, to: item.quantity - 1)
        }
    }

    func remove(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func clear() {
        items.removeAll()
        save()
    }

    private func updateQuantity(for id: UUID, to quantity: Int) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items[index].quantity = max(1, quantity)
        save()
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        userDefaults.set(data, forKey: storageKey)
    }
}
