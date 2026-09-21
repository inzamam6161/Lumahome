//
//  ProductImage.swift
//  LumaHome
//
//  Created by Inzamamul Haque on 06/09/26.
//

import SwiftUI

struct ProductImage: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Color.brandPaper
                    ProgressView()
                }

            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure:
                ZStack {
                    Color.brandPaper

                    Image(systemName: "chair.lounge.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }

            @unknown default:
                Color.brandPaper
            }
        }
        .clipped()
    }
}
