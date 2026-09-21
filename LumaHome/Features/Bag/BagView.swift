import SwiftUI

@MainActor
struct BagView: View {
    @ObservedObject var cartService: CartService
    @ObservedObject var orderService: OrderService

    @State private var placedOrder: Order?

    var body: some View {
        Group {
            if cartService.items.isEmpty {
                ContentUnavailableView(
                    "Your Bag Is Empty",
                    systemImage: "bag",
                    description: Text("Add a piece from Discover and it will stay here between launches.")
                )
            } else {
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(cartService.items) { item in
                            bagRow(item)
                        }

                        summaryCard
                    }
                    .padding(16)
                    .padding(.bottom, 100)
                }
            }
        }
        .background(Color.brandPaper.opacity(0.55))
        .navigationTitle("Bag")
        .safeAreaInset(edge: .bottom) {
            if !cartService.items.isEmpty {
                checkoutBar
            }
        }
        .alert(item: $placedOrder) { order in
            Alert(
                title: Text("Order Confirmed"),
                message: Text("\(order.reference) has been saved to Orders."),
                dismissButton: .default(Text("Done"))
            )
        }
    }

    private func bagRow(_ item: CartItem) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ProductImage(url: item.product.imageURL)
                .frame(width: 112, height: 118)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.product.name)
                            .font(.headline)
                            .foregroundStyle(Color.brandInk)
                            .lineLimit(2)

                        Text(item.selectedColor.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button(role: .destructive) {
                        cartService.remove(item)
                    } label: {
                        Image(systemName: "trash")
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Remove \(item.product.name) from bag")
                }

                Spacer(minLength: 4)

                HStack {
                    quantityControl(item)
                    Spacer()
                    Text(item.lineTotal.aedFormatted)
                        .font(.subheadline.bold())
                        .foregroundStyle(Color.brandInk)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .lumaCard()
    }

    private func quantityControl(_ item: CartItem) -> some View {
        HStack(spacing: 12) {
            Button {
                cartService.decrement(item)
            } label: {
                Image(systemName: "minus")
                    .font(.caption.weight(.bold))
            }
            .disabled(item.quantity <= 1)
            .opacity(item.quantity <= 1 ? 0.35 : 1)
            .accessibilityLabel("Decrease quantity")

            Text("\(item.quantity)")
                .font(.subheadline.monospacedDigit())
                .frame(minWidth: 20)

            Button {
                cartService.increment(item)
            } label: {
                Image(systemName: "plus")
                    .font(.caption.weight(.bold))
            }
            .accessibilityLabel("Increase quantity")
        }
        .foregroundStyle(Color.brandInk)
        .padding(.horizontal, 11)
        .frame(height: 36)
        .background(Color.brandPaper, in: Capsule())
        .buttonStyle(.plain)
    }

    private var summaryCard: some View {
        VStack(spacing: 14) {
            summaryRow(title: "Subtotal", value: cartService.subtotal.aedFormatted)
            summaryRow(
                title: "Delivery",
                value: cartService.deliveryFee == Decimal(0)
                    ? "Free"
                    : cartService.deliveryFee.aedFormatted
            )

            Divider()

            summaryRow(title: "Total", value: cartService.total.aedFormatted, emphasized: true)

            if cartService.deliveryFee > Decimal(0) {
                Text("Add more to reach AED 1,000 and unlock free delivery.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(18)
        .lumaCard()
    }

    private func summaryRow(
        title: String,
        value: String,
        emphasized: Bool = false
    ) -> some View {
        HStack {
            Text(title)
                .font(emphasized ? .headline : .subheadline)
            Spacer()
            Text(value)
                .font(emphasized ? .headline : .subheadline)
                .fontWeight(emphasized ? .bold : .medium)
        }
        .foregroundStyle(Color.brandInk)
    }

    private var checkoutBar: some View {
        VStack(spacing: 0) {
            Divider()
            Button {
                let order = orderService.placeOrder(
                    items: cartService.items,
                    total: cartService.total
                )
                placedOrder = order
                if order != nil {
                    cartService.clear()
                }
            } label: {
                HStack {
                    Text("Place Order")
                    Spacer()
                    Text(cartService.total.aedFormatted)
                }
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .frame(height: 54)
                .background(Color.brandInk, in: Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial)
        }
    }
}
