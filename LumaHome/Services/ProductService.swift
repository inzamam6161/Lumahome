//
//  ProductService.swift
//  LumaHome
//
//  Created by Inzamamul Haque on 06/09/26.
//

import Foundation

protocol ProductServiceProtocol: Sendable {
    func fetchProducts() async throws -> [Product]
}

enum ProductServiceError: LocalizedError {
    case catalogueNotFound

    var errorDescription: String? {
        "Products.json could not be found."
    }
}

actor LocalProductService: ProductServiceProtocol {
    func fetchProducts() async throws -> [Product] {
        guard let url = Bundle.main.url(
            forResource: "Products",
            withExtension: "json"
        ) else {
            throw ProductServiceError.catalogueNotFound
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([Product].self, from: data)
    }
}
