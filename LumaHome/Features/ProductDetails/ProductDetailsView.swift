import SwiftUI

@MainActor
struct ProductDetailsView: View {
    @StateObject private var viewModel: ProductDetailsViewModel

    init(
        product: Product,
        favoritesService: FavoritesService,
        cartService: CartService
    ) {
        _viewModel = StateObject(
            wrappedValue: ProductDetailsViewModel(
                product: product,
                favoritesService: favoritesService,
                cartService: cartService
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                productImage
                productInformation
                colorSelection
                quantitySelection
                deliveryInformation
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 170)
        }
        .background(Color.brandPaper.opacity(0.48))
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.toggleFavorite()
                } label: {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isFavorite ? Color.red : Color.brandInk)
                }
                .accessibilityLabel(
                    viewModel.isFavorite ? "Remove from favourites" : "Add to favourites"
                )
            }
        }
        .safeAreaInset(edge: .bottom) {
            addToBagBar
        }
    }

    private var productImage: some View {
        ZStack(alignment: .bottomLeading) {
            ProductImage(url: viewModel.product.imageURL)
                .frame(height: 410)

            HStack(spacing: 7) {
                Image(systemName: viewModel.product.category.icon)
                Text(viewModel.product.category.rawValue)
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.brandInk)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .padding(14)
        }
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .padding(.top, 8)
    }

    private var productInformation: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Text(viewModel.product.name)
                    .font(.system(size: 31, weight: .semibold, design: .serif))
                    .foregroundStyle(Color.brandInk)

                Spacer(minLength: 12)

                Label(
                    String(format: "%.1f", viewModel.product.rating),
                    systemImage: "star.fill"
                )
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.brandTerracotta)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.white, in: Capsule())
            }

            Text(viewModel.product.description)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(viewModel.product.price.aedFormatted)
                .font(.title2.bold())
                .foregroundStyle(Color.brandInk)
        }
    }

    private var colorSelection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Finish")
                    .font(.headline)
                Spacer()
                Text(viewModel.selectedColor.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                ForEach(viewModel.product.colors) { color in
                    colorButton(color)
                }
            }
        }
        .padding(18)
        .lumaCard()
    }

    private func colorButton(_ productColor: ProductColor) -> some View {
        let isSelected = productColor == viewModel.selectedColor

        return Button {
            viewModel.selectColor(productColor)
        } label: {
            VStack(spacing: 7) {
                Circle()
                    .fill(Color(hex: productColor.hex))
                    .frame(width: 42, height: 42)
                    .overlay {
                        Circle()
                            .stroke(Color.brandInk, lineWidth: isSelected ? 2 : 0)
                            .padding(-5)
                    }

                Text(productColor.name)
                    .font(.caption2)
                    .foregroundStyle(Color.brandInk)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(productColor.name)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var quantitySelection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Quantity")
                    .font(.headline)
                Text("Choose up to 9 pieces")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            HStack(spacing: 18) {
                quantityButton(systemImage: "minus", enabled: viewModel.quantity > 1) {
                    viewModel.decrementQuantity()
                }

                Text("\(viewModel.quantity)")
                    .font(.headline.monospacedDigit())
                    .frame(minWidth: 24)

                quantityButton(systemImage: "plus", enabled: viewModel.quantity < 9) {
                    viewModel.incrementQuantity()
                }
            }
        }
        .padding(18)
        .lumaCard()
    }

    private func quantityButton(
        systemImage: String,
        enabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .frame(width: 34, height: 34)
                .background(Color.brandPaper, in: Circle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.brandInk)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.35)
    }

    private var deliveryInformation: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Free delivery on orders over AED 1,000", systemImage: "truck.box.fill")
                .foregroundStyle(Color.brandSage)

            Label("30-day returns on unused pieces", systemImage: "arrow.uturn.backward.circle.fill")
                .foregroundStyle(Color.brandInk)

            if viewModel.product.supportsAR {
                Label("AR-ready product metadata included", systemImage: "arkit")
                    .foregroundStyle(Color.brandTerracotta)
            }
        }
        .font(.subheadline.weight(.medium))
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lumaCard()
    }

    private var addToBagBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.didAddToBag ? "Added to bag" : "Total")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(viewModel.totalPrice.aedFormatted)
                        .font(.headline)
                        .foregroundStyle(Color.brandInk)
                }

                Spacer()

                Button {
                    viewModel.addToBag()
                } label: {
                    Label(
                        viewModel.didAddToBag ? "Added" : "Add to Bag",
                        systemImage: viewModel.didAddToBag ? "checkmark" : "bag.badge.plus"
                    )
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 22)
                    .frame(height: 52)
                    .background(Color.brandInk, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }
}
