import SwiftUI

@MainActor
struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    @ObservedObject var favoritesService: FavoritesService
    @ObservedObject var cartService: CartService

    private let columns = [
        GridItem(.adaptive(minimum: 158, maximum: 240), spacing: 14)
    ]

    init(
        favoritesService: FavoritesService,
        cartService: CartService
    ) {
        self.favoritesService = favoritesService
        self.cartService = cartService
        _viewModel = StateObject(
            wrappedValue: FavoritesViewModel(
                favoritesService: favoritesService
            )
        )
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading favourites…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.favoriteProducts.isEmpty {
                ContentUnavailableView(
                    "No Favourites Yet",
                    systemImage: "heart",
                    description: Text("Tap the heart on a piece to save it for later.")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.favoriteProducts) { product in
                            ZStack(alignment: .topTrailing) {
                                NavigationLink {
                                    ProductDetailsView(
                                        product: product,
                                        favoritesService: favoritesService,
                                        cartService: cartService
                                    )
                                } label: {
                                    ProductCard(product: product)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    viewModel.remove(product)
                                } label: {
                                    Image(systemName: "heart.fill")
                                        .foregroundStyle(Color.red)
                                        .frame(width: 38, height: 38)
                                        .background(.ultraThinMaterial, in: Circle())
                                }
                                .buttonStyle(.plain)
                                .padding(10)
                                .accessibilityLabel("Remove \(product.name) from favourites")
                            }
                        }
                    }
                    .padding(16)
                    .padding(.bottom, 96)
                }
            }
        }
        .background(Color.brandPaper.opacity(0.55))
        .navigationTitle("Favourites")
        .task {
            await viewModel.loadProducts()
        }
        .alert("Unable to Load Products", isPresented: errorBinding) {
            Button("Retry") {
                Task { await viewModel.loadProducts() }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }

    private var errorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.errorMessage != nil },
            set: { isPresented in
                if !isPresented { viewModel.errorMessage = nil }
            }
        )
    }
}
