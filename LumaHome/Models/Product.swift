import Foundation

enum ProductCategory: String, Codable, CaseIterable, Identifiable {
    case living = "Living"
    case workspace = "Workspace"
    case lighting = "Lighting"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .living:
            return "sofa.fill"
        case .workspace:
            return "desktopcomputer"
        case .lighting:
            return "lamp.desk.fill"
        }
    }
}

struct ProductColor: Codable, Hashable, Identifiable {
    let name: String
    let hex: String

    var id: String { name }
}

struct Product: Codable, Hashable, Identifiable {
    let id: UUID
    let name: String
    let description: String
    let category: ProductCategory
    let price: Decimal
    let rating: Double
    let imageURL: URL
    let colors: [ProductColor]
    let supportsAR: Bool
}
