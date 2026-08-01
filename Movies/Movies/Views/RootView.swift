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

enum AppTab {
    case home
    case search
    case favourites
}

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        Group {
            switch selectedTab {
            case .home:
                HomeView()

            case .search:
                SearchView()

            case .favourites:
                FavouritesView()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: AppTab

    var body: some View {
        HStack {
            tabButton(
                title: "Home",
                icon: "house",
                selectedIcon: "house",
                tab: .home
            )

            Spacer()

            tabButton(
                title: "Search",
                icon: "magnifyingglass",
                selectedIcon: "magnifyingglass",
                tab: .search
            )

            Spacer()

            tabButton(
                title: "Favourites",
                icon: "bookmark",
                selectedIcon: "bookmark.fill",
                tab: .favourites
            )
        }
        .padding(.horizontal, 36)
        .frame(height: 62)
        .background(Color.movieBlack)
        }
    

    private func tabButton(
        title: String,
        icon: String,
        selectedIcon: String,
        tab: AppTab
    ) -> some View {
        Button {
            selectedTab = tab
        } label: {
            VStack(spacing: 4) {
                Image(
                    systemName: selectedTab == tab
                    ? selectedIcon
                    : icon
                )
                .font(.system(size: 16))

                Text(title)
                    .font(.system(size: 10))
            }
            .foregroundStyle(
                selectedTab == tab
                ? Color.cyan
                : Color.gray
            )
            .frame(width: 64)
        }
    }
}

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.movieBlack
                .ignoresSafeArea()

            Image("SplashPopcorn")
                .resizable()
                .scaledToFit()
                .frame(width: 210)
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
