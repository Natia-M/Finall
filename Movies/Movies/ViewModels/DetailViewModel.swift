//
//  DetailViewModel.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import Foundation
import Combine

@MainActor
final class DetailViewModel: ObservableObject {
    @Published private(set) var detail: MovieDetail?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let movie: Movie
    private let service: MovieProviding

    init(
        movie: Movie,
        service: MovieProviding = OMDbService()
    ) {
        self.movie = movie
        self.service = service
    }

    func load() async {
        guard detail == nil else {
            return
        }

        isLoading = true

        defer {
            isLoading = false
        }

        do {
            detail = try await service.details(id: movie.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
