//
//  SearchView.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//
import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var showSortMenu = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Search")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)

                    searchBar

                    if viewModel.isLoading {
                        Spacer()

                        ProgressView()
                            .frame(maxWidth: .infinity)

                        Spacer()

                    } else if viewModel.hasSearched &&
                                viewModel.movies.isEmpty {
                        SearchEmptyState()

                    } else {
                        searchResults
                    }
                }
                .padding(.top, 12)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )

                if showSortMenu {
                    SortMenu(
                        selection: $viewModel.sortOption
                    ) {
                        showSortMenu = false
                    }
                    .padding(.top, 82)
                    .padding(.trailing, 16)
                }
            }
            .background(Color.movieBlack)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 8) {
                TextField(
                    "Search movies",
                    text: $viewModel.query
                )
                .font(.system(size: 13))
                .onChange(of: viewModel.query) { _, _ in
                    viewModel.queryChanged()
                }

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 12)
            .frame(height: 38)
            .background(Color.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 9))

            Button {
                showSortMenu.toggle()
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 20))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal, 16)
    }

    private var searchResults: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.movies) { movie in
                    NavigationLink(value: movie) {
                        SearchResultRow(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct SearchResultRow: View {
    let movie: Movie

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            PosterImage(
                url: movie.posterURL,
                height: 142,
                width: 96
            )

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.white)
                    .lineLimit(2)

                infoRow(
                    icon: "star",
                    text: movie.imdbRating ?? "N/A",
                    color: .orange
                )

                infoRow(
                    icon: "ticket",
                    text: movie.genre ?? "Movie",
                    color: .white
                )

                infoRow(
                    icon: "calendar",
                    text: movie.year,
                    color: .white
                )

                infoRow(
                    icon: "clock",
                    text: movie.runtime ?? "N/A",
                    color: .white
                )
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }

    private func infoRow(
        icon: String,
        text: String,
        color: Color
    ) -> some View {
        HStack(spacing: 7) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .frame(width: 18)

            Text(text)
                .font(.system(size: 16))
        }
        .foregroundStyle(color)
    }
}

struct SearchEmptyState: View {
    var body: some View {
        Spacer()

        VStack(spacing: 10) {
            Text("Oh No Isn’t This So Embarrassing?")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(.white)

            Text("I cannot find any movie with this name.")
                .font(.system(size: 10))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)

        Spacer()
    }
}

struct SortMenu: View {
    @Binding var selection: SortOption
    let closeMenu: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            sortButton(.name)
            Divider().overlay(Color.white.opacity(0.08))

            sortButton(.genre)
            Divider().overlay(Color.white.opacity(0.08))

            sortButton(.year)
        }
        .frame(width: 120)
        .background(Color.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func sortButton(
        _ option: SortOption
    ) -> some View {
        Button {
            selection = option
            closeMenu()
        } label: {
            HStack(spacing: 8) {
                Image(
                    systemName: selection == option
                    ? "checkmark"
                    : ""
                )
                .font(.system(size: 10))
                .frame(width: 12)

                Text(option.rawValue)
                    .font(.system(size: 12))

                Spacer()
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .frame(height: 32)
        }
    }
}
