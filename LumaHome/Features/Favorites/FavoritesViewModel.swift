//
//  FavorirtesViewModel.swift
//  LumaHome
//
//  Created by Inzamamul Haque on 06/09/26.
//

import Combine
import Foundation

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var favoriteIDs: Set<UUID> = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let productService: ProductServiceProtocol
    private let favoritesService: FavoritesService

    init(
        productService: ProductServiceProtocol = LocalProductService(),
        favoritesService: FavoritesService
    ) {
        self.productService = productService
        self.favoritesService = favoritesService

        favoritesService.$favoriteIDs
            .assign(to: &$favoriteIDs)
    }

    var favoriteProducts: [Product] {
        products.filter {
            favoriteIDs.contains($0.id)
        }
    }

    func loadProducts() async {
        guard products.isEmpty else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            products = try await productService.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func remove(_ product: Product) {
        favoritesService.toggle(product)
    }
}
