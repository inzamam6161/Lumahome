import SwiftUI

@main
struct LumaHomeApp: App {
    @StateObject private var favoritesService = FavoritesService()
    @StateObject private var cartService = CartService()
    @StateObject private var orderService = OrderService()

    var body: some Scene {
        WindowGroup {
            RootView(
                favoritesService: favoritesService,
                cartService: cartService,
                orderService: orderService
            )
            .tint(Color.brandTerracotta)
        }
    }
}
