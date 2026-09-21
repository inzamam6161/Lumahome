import Foundation

enum OrderStatus: String, Codable, Hashable {
    case confirmed = "Confirmed"
}

struct Order: Codable, Hashable, Identifiable {
    let id: UUID
    let createdAt: Date
    let items: [CartItem]
    let total: Decimal
    let status: OrderStatus

    init(
        id: UUID = UUID(),
        createdAt: Date = Date(),
        items: [CartItem],
        total: Decimal,
        status: OrderStatus = .confirmed
    ) {
        self.id = id
        self.createdAt = createdAt
        self.items = items
        self.total = total
        self.status = status
    }

    var reference: String {
        "LH-\(id.uuidString.prefix(6).uppercased())"
    }

    var itemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
}
