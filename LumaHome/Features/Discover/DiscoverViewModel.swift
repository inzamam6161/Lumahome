import Combine
import Foundation

enum ProductSort: String, CaseIterable, Identifiable {
    case featured = "Featured"
    case rating = "Top rated"
    case priceLow = "Price: Low to High"
    case priceHigh = "Price: High to Low"

    var id: String { rawValue }
}

@MainActor
final class DiscoverViewModel: ObservableObject {
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    @Published var searchText = ""
    @Published var selectedCategory: ProductCategory?
    @Published var sort: ProductSort = .featured
    @Published var errorMessage: String?

    private let productService: ProductServiceProtocol

    init(productService: ProductServiceProtocol = LocalProductService()) {
        self.productService = productService
    }

    var filteredProducts: [Product] {
        let filtered = products.filter { product in
            let matchesCategory = selectedCategory == nil || product.category == selectedCategory
            let matchesSearch = searchText.isEmpty ||
                product.name.localizedCaseInsensitiveContains(searchText) ||
                product.description.localizedCaseInsensitiveContains(searchText) ||
                product.category.rawValue.localizedCaseInsensitiveContains(searchText)

            return matchesCategory && matchesSearch
        }

        switch sort {
        case .featured:
            return filtered
        case .rating:
            return filtered.sorted { $0.rating > $1.rating }
        case .priceLow:
            return filtered.sorted { $0.price < $1.price }
        case .priceHigh:
            return filtered.sorted { $0.price > $1.price }
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
}
