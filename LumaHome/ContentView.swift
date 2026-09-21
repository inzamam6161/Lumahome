import SwiftUI

struct ContentView: View {
    @StateObject private var favoritesService = FavoritesService()
    @StateObject private var cartService = CartService()
    @StateObject private var orderService = OrderService()

    var body: some View {
        RootView(
            favoritesService: favoritesService,
            cartService: cartService,
            orderService: orderService
        )
    }
}

#Preview {
    ContentView()
}
