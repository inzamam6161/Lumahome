import SwiftUI

@MainActor
struct RootView: View {
    @StateObject private var viewModel = RootViewModel()

    let favoritesService: FavoritesService
    let cartService: CartService
    let orderService: OrderService

    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            NavigationStack {
                DiscoverView(
                    favoritesService: favoritesService,
                    cartService: cartService
                )
            }
            .tabItem {
                Label("Discover", systemImage: "sparkles")
            }
            .tag(RootViewModel.Tab.discover)

            NavigationStack {
                FavoritesView(
                    favoritesService: favoritesService,
                    cartService: cartService
                )
            }
            .tabItem {
                Label("Favourites", systemImage: "heart.fill")
            }
            .tag(RootViewModel.Tab.favorites)

            NavigationStack {
                BagView(
                    cartService: cartService,
                    orderService: orderService
                )
            }
            .tabItem {
                Label("Bag", systemImage: "bag.fill")
            }
            .badge(cartService.itemCount)
            .tag(RootViewModel.Tab.cart)

            NavigationStack {
                OrdersView(orderService: orderService)
            }
            .tabItem {
                Label("Orders", systemImage: "shippingbox.fill")
            }
            .tag(RootViewModel.Tab.orders)
        }
    }
}

#Preview {
    RootView(
        favoritesService: FavoritesService(),
        cartService: CartService(),
        orderService: OrderService()
    )
}
