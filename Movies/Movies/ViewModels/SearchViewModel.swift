//
//  SearchViewModel.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import Foundation
import Combine

enum SortOption: String, CaseIterable, Identifiable {
    case name = "Name"
    case genre = "Genre"
    case year = "Year"

    var id: String {
        rawValue
    }
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var query = ""

    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasSearched = false

    @Published var errorMessage: String?

    @Published var sortOption: SortOption = .name {
        didSet {
            if sortOption == .genre {
                Task {
                    await loadGenresAndSort()
                }
            } else {
                sort()
            }
        }
    }

    private let service: MovieProviding
    private var searchTask: Task<Void, Never>?

    init(service: MovieProviding = OMDbService()) {
        self.service = service
    }

    deinit {
        searchTask?.cancel()
    }

    func queryChanged() {
        searchTask?.cancel()

        let text = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard text.count >= 2 else {
            movies = []
            hasSearched = false
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(450))

            guard !Task.isCancelled else {
                return
            }

            await self?.search()
        }
    }

    func search() async {
        isLoading = true
        errorMessage = nil
        hasSearched = true

        defer {
            isLoading = false
        }

        do {
            movies = try await service.search(title: query)
            sort()
        } catch {
            movies = []
            errorMessage = error.localizedDescription
        }
    }

    func sort() {
        switch sortOption {
        case .name:
            movies.sort {
                $0.title.localizedCaseInsensitiveCompare($1.title)
                == .orderedAscending
            }

        case .genre:
            movies.sort {
                ($0.genre ?? "")
                    .localizedCaseInsensitiveCompare($1.genre ?? "")
                == .orderedAscending
            }

        case .year:
            movies.sort {
                $0.year > $1.year
            }
        }
    }

    private func loadGenresAndSort() async {
        for index in movies.indices where movies[index].genre == nil {
            guard !Task.isCancelled else {
                return
            }

            if let detail = try? await service.details(
                id: movies[index].id
            ) {
                movies[index].genre = detail.genre
            }
        }

        sort()
    }
}
