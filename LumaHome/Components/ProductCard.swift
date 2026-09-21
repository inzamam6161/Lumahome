import SwiftUI

struct ProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProductImage(url: product.imageURL)
                .frame(height: 190)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(product.name)
                        .font(.headline)
                        .foregroundStyle(Color.brandInk)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .layoutPriority(1)

                    Spacer(minLength: 6)

                    Label(String(format: "%.1f", product.rating), systemImage: "star.fill")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color.brandTerracotta)
                }

                Text(product.category.rawValue.uppercased())
                    .font(.caption2.weight(.semibold))
                    .tracking(0.7)
                    .foregroundStyle(.secondary)

                Text(product.price.aedFormatted)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.brandInk)
            }
            .padding(.horizontal, 2)
            .padding(.bottom, 4)
        }
        .padding(8)
        .lumaCard()
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens product details")
    }
}
