import SwiftUI

@MainActor
struct DiscoverView: View {
    @StateObject private var viewModel = DiscoverViewModel()
    @ObservedObject var favoritesService: FavoritesService
    @ObservedObject var cartService: CartService

    private let columns = [
        GridItem(.adaptive(minimum: 158, maximum: 240), spacing: 14)
    ]

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                hero
                categories
                collectionHeader
                content
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 120)
        }
        .background(Color.brandPaper.opacity(0.55))
        .navigationTitle("LumaHome")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchText, prompt: "Search furniture")
        .navigationDestination(for: Product.self) { product in
            ProductDetailsView(
                product: product,
                favoritesService: favoritesService,
                cartService: cartService
            )
        }
        .task {
            await viewModel.loadProducts()
        }
        .refreshable {
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

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.brandInk, Color.brandTerracotta.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "chair.lounge.fill")
                .font(.system(size: 116, weight: .light))
                .foregroundStyle(Color.white.opacity(0.10))
                .offset(x: 160, y: -10)

            VStack(alignment: .leading, spacing: 10) {
                Text("CURATED FOR CALM SPACES")
                    .font(.caption2.weight(.bold))
                    .tracking(1.2)
                    .foregroundStyle(Color.brandSand)

                Text("Find pieces that\nfeel like home.")
                    .font(.system(size: 30, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)

                Label("Free delivery over AED 1,000", systemImage: "truck.box.fill")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(22)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.top, 8)
        .accessibilityElement(children: .combine)
    }

    private var categories: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                categoryButton(title: "All", icon: "square.grid.2x2.fill", category: nil)

                ForEach(ProductCategory.allCases) { category in
                    categoryButton(
                        title: category.rawValue,
                        icon: category.icon,
                        category: category
                    )
                }
            }
            .padding(.vertical, 2)
            .padding(.trailing, 24)
        }
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }

    private var collectionHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.selectedCategory?.rawValue ?? "The collection")
                    .font(.title2.bold())

                Text("\(viewModel.filteredProducts.count) thoughtfully selected pieces")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Menu {
                Picker("Sort products", selection: $viewModel.sort) {
                    ForEach(ProductSort.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.subheadline.weight(.semibold))
                    .frame(width: 38, height: 38)
                    .background(Color.white, in: Circle())
                    .foregroundStyle(Color.brandInk)
            }
            .accessibilityLabel("Sort products")
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            VStack(spacing: 12) {
                ProgressView()
                Text("Loading collection…")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, minHeight: 300)
        } else if viewModel.filteredProducts.isEmpty {
            ContentUnavailableView(
                "No Furniture Found",
                systemImage: "magnifyingglass",
                description: Text("Try another search or category.")
            )
            .frame(minHeight: 300)
        } else {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.filteredProducts) { product in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink(value: product) {
                            ProductCard(product: product)
                        }
                        .buttonStyle(.plain)

                        Button {
                            favoritesService.toggle(product)
                        } label: {
                            Image(systemName: favoritesService.contains(product) ? "heart.fill" : "heart")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(
                                    favoritesService.contains(product) ? Color.red : Color.brandInk
                                )
                                .frame(width: 38, height: 38)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                        .buttonStyle(.plain)
                        .padding(10)
                        .accessibilityLabel(
                            favoritesService.contains(product)
                                ? "Remove \(product.name) from favourites"
                                : "Add \(product.name) to favourites"
                        )
                    }
                }
            }
        }
    }

    private func categoryButton(
        title: String,
        icon: String,
        category: ProductCategory?
    ) -> some View {
        let isSelected = viewModel.selectedCategory == category

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectedCategory = category
            }
        } label: {
            Label(title, systemImage: icon)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(isSelected ? Color.white : Color.brandInk)
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(isSelected ? Color.brandInk : Color.white, in: Capsule())
        }
        .buttonStyle(.plain)
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

#Preview {
    NavigationStack {
        DiscoverView(
            favoritesService: FavoritesService(),
            cartService: CartService()
        )
    }
}
