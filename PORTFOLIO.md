# LumaHome — Portfolio Case Study

## One-line pitch

A native SwiftUI furniture shopping experience that turns a small local catalogue into a complete browse → save → configure → bag → checkout → order-history flow.

## Problem

Furniture shopping demos often stop at a product grid. LumaHome focuses on the product experience around that grid: discovery, filtering, product configuration, persistence, checkout feedback and stateful order history.

## What to show in a portfolio

1. **Discover** — editorial hero, categories, search, sort and responsive product grid.
2. **Product details** — finish selection, quantity, pricing and add-to-bag CTA.
3. **Bag** — persistent cart, quantity editing, free-delivery threshold and local checkout.
4. **Orders** — generated local order reference, item summary and persisted history.
5. **Favourites** — save/unsave behavior persisted across launches.

## Engineering talking points

- File-system-synchronized Xcode project keeps new feature files automatically in the target.
- `LocalProductService` keeps catalogue loading behind a protocol for future API replacement.
- Favourites, bag and orders each have focused persistence services rather than storing business state inside views.
- Pricing is represented with `Decimal` instead of floating-point values.
- Product search/filter/sort logic lives in `DiscoverViewModel`.
- Product configuration lives in `ProductDetailsViewModel`.
- Shared visual language is centralized in `Theme.swift` and the `lumaCard()` modifier.
- Empty/loading/error states are part of the main UX, not afterthoughts.

## Honest scope

This is a portfolio commerce simulation. It does not claim a production payment system, inventory backend, fulfilment service or completed AR placement feature. AR support is represented only as product metadata for future RealityKit/ARKit integration.

## Suggested screenshots

- Discover hero + product grid
- Search/filter state
- Product detail + finish selection
- Bag with multiple items
- Order confirmation / Orders history
- Favourites grid

## Resume bullet

**LumaHome — SwiftUI iOS app:** Built a native furniture discovery and shopping experience with responsive catalogue browsing, search/filter/sort, persistent favourites, configurable product details, local cart pricing, checkout and order history using SwiftUI, Combine, async/await and Codable persistence.
