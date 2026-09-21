# LumaHome

### Native iOS Furniture Discovery & Shopping Experience

LumaHome is a polished SwiftUI portfolio application for browsing a curated furniture catalogue, saving favourites, configuring finishes, building a persistent shopping bag and completing a local checkout flow with order history.

The project is intentionally local-first for portfolio demonstration: catalogue data ships with the app, favourites/bag/orders persist on device, and product photography is loaded from remote image URLs.

## Product Experience

- Curated Discover experience with editorial hero treatment
- Category filtering, search and multiple sort modes
- Responsive product grid that scales from iPhone to iPad
- Persistent favourites
- Product details with finish selection and quantity controls
- Persistent shopping bag with quantity editing and delivery calculation
- Local checkout flow and order confirmation
- Persistent order history with reference numbers and order summaries
- Loading, empty and failure states
- VoiceOver-friendly labels on important actions

## Architecture

```text
SwiftUI Views
    ↓
ObservableObject View Models / Services
    ↓
Local product catalogue + UserDefaults persistence
```

Key responsibilities:

```text
Services/ProductService.swift     local catalogue loading
Services/FavoritesService.swift   persistent favourites
Services/CartService.swift        persistent bag + pricing
Services/OrderService.swift       local checkout + order history
Features/Discover                 browse/search/filter/sort
Features/ProductDetails           configuration + add-to-bag
Features/Bag                      cart management + checkout
Features/Orders                   persisted purchase history
```

## Design System

LumaHome uses a warm editorial palette inspired by natural materials: ink, paper, terracotta, sand and sage. Shared card styling and spacing keep Discover, Favourites, Bag and Orders visually consistent.

## Technology

- Swift
- SwiftUI
- MVVM-style presentation separation
- Combine / ObservableObject
- async/await catalogue loading
- UserDefaults + Codable local persistence
- AsyncImage
- NavigationStack
- Accessibility labels and semantic states

## Running

Open `LumaHome.xcodeproj` in Xcode, select an iPhone or iPad Simulator and run the `LumaHome` scheme.

The project targets iOS 17+ so the portfolio app can use modern SwiftUI navigation and empty-state APIs while still supporting a meaningful device range.

## Portfolio Notes

LumaHome demonstrates product UI engineering rather than a production commerce backend. Checkout and order status are intentionally deterministic and stored locally. `supportsAR` is catalogue metadata only; the interface labels AR-capable products as **AR-ready** and does not claim a completed RoomPlan/ARKit placement implementation.

### Suggested portfolio summary

> Built a native SwiftUI furniture shopping experience with responsive discovery, search/filter/sort, persistent favourites, configurable product details, a local shopping bag, checkout flow and order history. Structured the app around focused services and view models, with a reusable visual system and accessibility-aware interactions.

## Next Release Gates

- Physical-device validation
- Snapshot/UI test target
- Store-ready app icon and screenshots
- Production product/checkout API
- Optional ARKit/RealityKit product placement for AR-ready catalogue items
