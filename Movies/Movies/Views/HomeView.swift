//
//  HomeView.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 10),
        count: 3
    )

    var body: some View {
        NavigationStack {
            ScrollView {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView()
                        .padding(.top, 120)
                } else {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(viewModel.movies) { movie in
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
            .background(Color.movieBlack)
            .navigationTitle("Movies")
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .task {
                await viewModel.load()
            }
            .alert(
                "Could not load movies",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: {
                        if !$0 {
                            viewModel.errorMessage = nil
                        }
                    }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}

struct PosterGridItem: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            PosterImage(
                url: movie.posterURL,
                height: 138
            )

            Text(movie.title)
                .font(.caption2)
                .lineLimit(2)
                .foregroundStyle(.white)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
        }
    }
}
