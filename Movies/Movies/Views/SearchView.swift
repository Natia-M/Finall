//
//  SearchView.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                searchBar

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if viewModel.hasSearched &&
                            viewModel.movies.isEmpty {
                    EmptySearchView()
                } else {
                    SearchResultsList(movies: viewModel.movies)
                }
            }
            .background(Color.movieBlack)
            .navigationTitle("Search")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)

                TextField(
                    "Search movies",
                    text: $viewModel.query
                )
                .onChange(of: viewModel.query) { _, _ in
                    viewModel.queryChanged()
                }
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await viewModel.search()
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Menu {
                Picker(
                    "Sort",
                    selection: $viewModel.sortOption
                ) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue)
                            .tag(option)
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SearchResultsList: View {
    let movies: [Movie]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(movies) { movie in
                    NavigationLink(value: movie) {
                        SearchRow(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct SearchRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            PosterImage(
                url: movie.posterURL,
                height: 105,
                width: 72
            )

            VStack(alignment: .leading, spacing: 7) {
                Text(movie.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                Label(movie.year, systemImage: "calendar")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(movie.genre ?? "Movie")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(8)
        .background(Color.cardGray.opacity(0.65))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct EmptySearchView: View {
    var body: some View {
        Spacer()

        VStack(spacing: 12) {
            Text("Oh No Isn’t This So Embarrassing?")
                .font(.subheadline.weight(.bold))

            Text("I cannot find any movie with this name.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding()

        Spacer()
    }
}
