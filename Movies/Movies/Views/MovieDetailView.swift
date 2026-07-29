//
//  MovieDetailView.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    @StateObject private var viewModel: DetailViewModel
    @EnvironmentObject private var favourites: FavouritesStore

    init(movie: Movie) {
        self.movie = movie

        _viewModel = StateObject(
            wrappedValue: DetailViewModel(movie: movie)
        )
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 160)

            } else if let detail = viewModel.detail {
                detailContent(detail)

            } else {
                ContentUnavailableView(
                    "Movie unavailable",
                    systemImage: "film",
                    description: Text(
                        viewModel.errorMessage ??
                        "Please try again later."
                    )
                )
            }
        }
        .background(Color.movieBlack)
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    private func detailContent(
        _ detail: MovieDetail
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            PosterImage(
                url: detail.posterURL,
                height: 270
            )
            .frame(maxWidth: .infinity)

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(detail.title)
                        .font(.title3.bold())

                    Text(detail.genre)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button {
                    favourites.toggle(detail: detail)
                } label: {
                    Image(
                        systemName: favourites.contains(movie)
                        ? "heart.fill"
                        : "heart"
                    )
                    .font(.title3)
                    .foregroundStyle(
                        favourites.contains(movie)
                        ? .red
                        : .white
                    )
                }
            }

            HStack(spacing: 16) {
                Label(detail.year, systemImage: "calendar")
                Label(detail.runtime, systemImage: "clock")
                Label(detail.imdbRating, systemImage: "star.fill")
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            Divider()
                .overlay(Color.gray.opacity(0.45))

            Text("About Movie")
                .font(.subheadline.bold())

            Text(detail.plot)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .lineSpacing(3)

            if detail.director != "N/A" {
                Text("Director: \(detail.director)")
                    .font(.footnote.weight(.medium))
            }
        }
        .padding(.bottom, 28)
    }
}

struct PosterImage: View {
    let url: URL?
    let height: CGFloat
    var width: CGFloat? = nil

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()

            case .failure:
                placeholder

            default:
                placeholder
                    .overlay {
                        ProgressView()
                            .controlSize(.small)
                    }
            }
        }
        .frame(width: width, height: height)
        .frame(maxWidth: width == nil ? .infinity : nil)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }

    private var placeholder: some View {
        ZStack {
            Color.cardGray

            Image(systemName: "film")
                .foregroundStyle(.secondary)
        }
    }
}
