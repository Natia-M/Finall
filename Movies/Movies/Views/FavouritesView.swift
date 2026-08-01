//
//  FavouritesView.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject private var favourites: FavouritesStore

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 10),
        count: 3
    )

    var body: some View {
        NavigationStack {
            Group {
                if favourites.movies.isEmpty {
                    VStack(spacing: 10) {
                        Spacer()

                        Text("No Favourites Yet")
                            .font(.subheadline.weight(.bold))

                        Text(
                            "All movies marked as favourite will be added here"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(width: 490)

                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: columns,
                            spacing: 18
                        ) {
                            ForEach(favourites.movies) { movie in
                                NavigationLink(value: movie) {
                                    PosterGridItem(movie: movie)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                }
            }
            .background(Color.movieBlack)
            .navigationTitle("Favourites")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }
}
