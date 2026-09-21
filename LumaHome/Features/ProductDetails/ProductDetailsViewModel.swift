import Combine
import Foundation

@MainActor
final class ProductDetailsViewModel: ObservableObject {
    let product: Product

    @Published private(set) var selectedColor: ProductColor
    @Published private(set) var isFavorite = false
    @Published var quantity = 1
    @Published private(set) var didAddToBag = false

    private let favoritesService: FavoritesService
    private let cartService: CartService

    init(
        product: Product,
        favoritesService: FavoritesService,
        cartService: CartService
    ) {
        self.product = product
        self.favoritesService = favoritesService
        self.cartService = cartService

        selectedColor = product.colors.first ?? ProductColor(
            name: "Default",
            hex: "D8C3A5"
        )

        favoritesService.$favoriteIDs
            .map { $0.contains(product.id) }
            .removeDuplicates()
            .assign(to: &$isFavorite)
    }

    var totalPrice: Decimal {
        product.price * Decimal(quantity)
    }

    func selectColor(_ color: ProductColor) {
        selectedColor = color
        didAddToBag = false
    }

    func toggleFavorite() {
        favoritesService.toggle(product)
    }

    func incrementQuantity() {
        quantity = min(quantity + 1, 9)
        didAddToBag = false
    }

    func decrementQuantity() {
        quantity = max(quantity - 1, 1)
        didAddToBag = false
    }

    func addToBag() {
        cartService.add(
            product: product,
            color: selectedColor,
            quantity: quantity
        )
        didAddToBag = true
    }
}
