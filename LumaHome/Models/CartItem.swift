import Foundation

struct CartItem: Codable, Hashable, Identifiable {
    let id: UUID
    let product: Product
    let selectedColor: ProductColor
    var quantity: Int

    init(
        id: UUID = UUID(),
        product: Product,
        selectedColor: ProductColor,
        quantity: Int
    ) {
        self.id = id
        self.product = product
        self.selectedColor = selectedColor
        self.quantity = max(1, quantity)
    }

    var lineTotal: Decimal {
        product.price * Decimal(quantity)
    }
}
