import Foundation
import SwiftUI

extension Color {
    static let brandInk = Color(red: 0.11, green: 0.10, blue: 0.09)
    static let brandPaper = Color(red: 0.97, green: 0.95, blue: 0.91)
    static let brandTerracotta = Color(red: 0.67, green: 0.35, blue: 0.22)
    static let brandSage = Color(red: 0.42, green: 0.49, blue: 0.39)
    static let brandSand = Color(red: 0.90, green: 0.85, blue: 0.76)
    static let brandSurface = Color.white.opacity(0.92)

    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        let value = UInt64(cleanedHex, radix: 16) ?? 0
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
    }
}

extension Decimal {
    var aedFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "AED"
        formatter.currencySymbol = "AED "
        formatter.maximumFractionDigits = 0

        return formatter.string(from: self as NSDecimalNumber) ?? "AED \(self)"
    }
}

extension Date {
    var shortOrderDate: String {
        formatted(date: .abbreviated, time: .omitted)
    }
}

struct LumaCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.brandSurface)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 16, y: 8)
    }
}

extension View {
    func lumaCard() -> some View {
        modifier(LumaCardStyle())
    }
}
