//
//  FavoritesService.swift
//  LumaHome
//
//  Created by Inzamamul Haque on 06/09/26.
//

import Combine
import Foundation

@MainActor
final class FavoritesService: ObservableObject {
    @Published private(set) var favoriteIDs: Set<UUID>

    private let userDefaults: UserDefaults
    private let storageKey = "lumahome.favorite.products"

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        let savedIDs = userDefaults.stringArray(
            forKey: storageKey
        ) ?? []

        favoriteIDs = Set(
            savedIDs.compactMap(UUID.init(uuidString:))
        )
    }

    func contains(_ product: Product) -> Bool {
        favoriteIDs.contains(product.id)
    }

    func toggle(_ product: Product) {
        if contains(product) {
            favoriteIDs.remove(product.id)
        } else {
            favoriteIDs.insert(product.id)
        }

        save()
    }

    private func save() {
        let values = favoriteIDs.map(\.uuidString)
        userDefaults.set(values, forKey: storageKey)
    }
}
