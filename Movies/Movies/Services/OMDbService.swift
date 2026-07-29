//
//  OMDbService.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import Foundation

protocol MovieProviding {
    func search(title: String) async throws -> [Movie]
    func details(id: String) async throws -> MovieDetail
}

enum APIError: LocalizedError {
    case message(String)
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .message(let message):
            return message
        case .invalidURL:
            return "არასწორი მისამართი."
        }
    }
}

final class OMDbService: MovieProviding {
    private let apiKey = "fd67c604"
    private let baseURL = "https://www.omdbapi.com/"

    func search(title: String) async throws -> [Movie] {
        let response: SearchResponse = try await request([
            "s": title,
            "type": "movie",
            "page": "1"
        ])

        guard response.response == "True" else {
            throw APIError.message(response.error ?? "ფილმები ვერ მოიძებნა.")
        }

        return response.search ?? []
    }

    func details(id: String) async throws -> MovieDetail {
        let response: MovieDetail = try await request(["i": id])

        guard response.response == "True" else {
            throw APIError.message(response.error ?? "დეტალები ვერ მოიძებნა.")
        }

        return response
    }

    private func request<T: Decodable>(
        _ parameters: [String: String]
    ) async throws -> T {
        var components = URLComponents(string: baseURL)

        components?.queryItems =
            [URLQueryItem(name: "apikey", value: apiKey)] +
            parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw APIError.message("სერვერის შეცდომა.")
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
