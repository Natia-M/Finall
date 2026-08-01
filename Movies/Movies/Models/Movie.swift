//
//  Movie.swift
//  Movies
//
//  Created by Natia on 29/07/2026.
//

import Foundation

struct SearchResponse: Decodable {
    let search: [Movie]?
    let response: String
    let error: String?

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case response = "Response"
        case error = "Error"
    }
}

struct Movie: Identifiable, Codable, Hashable {
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    var genre: String?
    var imdbRating: String? = nil
    var runtime: String? = nil
    var id: String {
        imdbID
    }

    var posterURL: URL? {
        poster == "N/A" ? nil : URL(string: poster)
    }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
        case genre = "Genre"
    }
}

struct MovieDetail: Decodable {
    let title: String
    let year: String
    let runtime: String
    let genre: String
    let director: String
    let plot: String
    let poster: String
    let imdbID: String
    let imdbRating: String
    let response: String
    let error: String?

    var posterURL: URL? {
        poster == "N/A" ? nil : URL(string: poster)
    }

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case plot = "Plot"
        case poster = "Poster"
        case imdbID
        case imdbRating
        case response = "Response"
        case error = "Error"
    }
}
