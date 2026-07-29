//
//  FavouritesStore.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import Foundation
import Combine

@MainActor
final class FavouritesStore: ObservableObject {
    @Published private(set) var movies: [Movie] = [] {
        didSet {
            save()
        }
    }

    private let storageKey = "favouriteMovies"

    init() {
        guard
            let data = UserDefaults.standard.data(forKey: storageKey),
            let savedMovies = try? JSONDecoder().decode(
                [Movie].self,
                from: data
            )
        else {
            return
        }

        movies = savedMovies
    }

    func contains(_ movie: Movie) -> Bool {
        movies.contains { $0.id == movie.id }
    }
    
    func toggle(_ movie: Movie) {
        if contains(movie) {
            movies.removeAll { $0.id == movie.id }
        } else {
            movies.insert(movie, at: 0)
        }
    }

    func toggle(detail: MovieDetail) {
        let movie = Movie(
            title: detail.title,
            year: detail.year,
            imdbID: detail.imdbID,
            type: "movie",
            poster: detail.poster,
            genre: detail.genre
        )

        toggle(movie)
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(movies) else {
            return
        }

        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
