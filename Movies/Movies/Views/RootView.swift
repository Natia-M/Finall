//
//  RootView.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import SwiftUI

struct RootView: View {
    @State private var splashVisible = true

    var body: some View {
        ZStack {
            MainTabView()
                .opacity(splashVisible ? 0 : 1)

            if splashVisible {
                SplashView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(1.2))

            withAnimation(.easeOut(duration: 0.35)) {
                splashVisible = false
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "bookmark")
                }
        }
        .tint(.cyan)
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.movieBlack
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "popcorn.fill")
                    .font(.system(size: 82))
                    .foregroundStyle(.white, .yellow)

                Text("MOVIES")
                    .font(.title.bold())
                    .tracking(5)
            }
        }
    }
}

extension Color {
    static let movieBlack = Color(
        red: 0.055,
        green: 0.055,
        blue: 0.06
    )

    static let cardGray = Color(
        red: 0.12,
        green: 0.125,
        blue: 0.15
    )
}
