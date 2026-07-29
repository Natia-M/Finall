//
//  HomeViewModel.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: MovieProviding

    init(service: MovieProviding = OMDbService()) {
        self.service = service
    }

    func load() async {
        guard movies.isEmpty else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            async let marvelMovies = service.search(title: "marvel")
            async let sonicMovies = service.search(title: "sonic")

            let firstResults = try await marvelMovies
            let secondResults = try await sonicMovies

            let allMovies = firstResults + secondResults

            var movieIDs = Set<String>()

            movies = allMovies.filter {
                movieIDs.insert($0.id).inserted
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
