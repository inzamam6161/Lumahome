import SwiftUI

@MainActor
struct OrdersView: View {
    @ObservedObject var orderService: OrderService

    var body: some View {
        Group {
            if orderService.orders.isEmpty {
                ContentUnavailableView(
                    "No Orders Yet",
                    systemImage: "shippingbox",
                    description: Text("Completed checkouts will appear here as a local order history.")
                )
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(orderService.orders) { order in
                            orderCard(order)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .background(Color.brandPaper.opacity(0.55))
        .navigationTitle("Orders")
    }

    private func orderCard(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.reference)
                        .font(.headline)
                        .foregroundStyle(Color.brandInk)

                    Text(order.createdAt.shortOrderDate)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(order.status.rawValue)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.brandSage)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.brandSage.opacity(0.12), in: Capsule())
            }

            HStack(spacing: -12) {
                ForEach(Array(order.items.prefix(3).enumerated()), id: \.element.id) { _, item in
                    ProductImage(url: item.product.imageURL)
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                }

                if order.items.count > 3 {
                    Text("+\(order.items.count - 3)")
                        .font(.caption.bold())
                        .frame(width: 56, height: 56)
                        .background(Color.brandPaper, in: Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                }
            }

            Divider()

            HStack {
                Label("\(order.itemCount) item\(order.itemCount == 1 ? "" : "s")", systemImage: "bag.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(order.total.aedFormatted)
                    .font(.headline)
                    .foregroundStyle(Color.brandInk)
            }
        }
        .padding(18)
        .lumaCard()
        .accessibilityElement(children: .combine)
    }
}
