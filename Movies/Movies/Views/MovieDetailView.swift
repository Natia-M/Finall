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
    @Environment(\.dismiss) private var dismiss

    init(movie: Movie) {
        self.movie = movie

        _viewModel = StateObject(
            wrappedValue: DetailViewModel(movie: movie)
        )
    }

    var body: some View {
        VStack(spacing: 0) {
            navigationBar

            ScrollView {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 150)

                } else if let detail = viewModel.detail {
                    detailContent(detail)

                } else {
                    Text(viewModel.errorMessage ?? "Movie unavailable")
                        .foregroundStyle(.gray)
                        .padding(.top, 120)
                }
            }
        }
        .background(Color.movieBlack)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.load()
        }
    }

    private var navigationBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                    Text("Movies")
                }
                .font(.system(size: 15))
                .foregroundStyle(.cyan)
            }

            Spacer()

            Text(movie.title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)

            Spacer()

            Color.clear
                .frame(width: 58)
        }
        .padding(.horizontal, 14)
        .frame(height: 48)
    }

    private func detailContent(
        _ detail: MovieDetail
    ) -> some View {
        VStack(spacing: 0) {
            movieHeader(detail)

            HStack(spacing: 12) {
                infoItem(
                    icon: "calendar",
                    text: detail.year
                )

                Divider()
                    .frame(height: 20)
                    .overlay(Color.gray.opacity(0.6))

                infoItem(
                    icon: "clock",
                    text: detail.runtime
                )

                Divider()
                    .frame(height: 20)
                    .overlay(Color.gray.opacity(0.6))

                infoItem(
                    icon: "ticket",
                    text: detail.genre
                        .components(separatedBy: ",")
                        .first ?? "Movie"
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)

            HStack {
                Text("About Movie")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Spacer()

                Button {
                    favourites.toggle(detail: detail)
                } label: {
                    Image(
                        systemName: favourites.contains(movie)
                        ? "heart.fill"
                        : "heart"
                    )
                    .font(.system(size: 22))
                    .foregroundStyle(
                        favourites.contains(movie)
                        ? .red
                        : .white
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            Rectangle()
                .fill(Color.gray.opacity(0.45))
                .frame(height: 3)
                .padding(.horizontal, 16)

            Text(detail.plot)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.8))
                .lineSpacing(4)
                .padding(.horizontal, 16)
                .padding(.top, 22)

            if detail.director != "N/A" {
                Text("Director: \(detail.director)")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 18)
            }
        }
        .padding(.bottom, 26)
    }

    private func movieHeader(
        _ detail: MovieDetail
    ) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: detail.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 12)
                        .overlay(Color.black.opacity(0.25))

                default:
                    Color.cardGray
                }
            }
            .frame(height: 270)
            .frame(maxWidth: .infinity)
            .clipped()

            LinearGradient(
                colors: [
                    .clear,
                    Color.movieBlack.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(alignment: .bottom, spacing: 12) {
                PosterImage(
                    url: detail.posterURL,
                    height: 118,
                    width: 78
                )

                Text(detail.title)
                    .font(.system(size: 21, weight: .bold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .padding(.bottom, 8)

                Spacer()
            }
            .padding(.horizontal, 16)
            .offset(y: 46)
        }
        .frame(height: 270)
        .padding(.bottom, 58)
    }

    private func infoItem(
        icon: String,
        text: String
    ) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 12))

            Text(text)
                .font(.system(size: 12))
                .lineLimit(1)
        }
        .foregroundStyle(.gray)
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

            default:
                ZStack {
                    Color.cardGray

                    Image(systemName: "film")
                        .foregroundStyle(.gray)
                }
            }
        }
        .frame(width: width, height: height)
        .frame(maxWidth: width == nil ? .infinity : nil)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 7))
    }
}
