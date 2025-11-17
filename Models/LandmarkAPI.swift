//
//  LandmarkAPI.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import Foundation

enum LandmarkAPI {

    /// Fetches all landmarks from Back4App (name + image URL).
    /// Falls back to empty list on failure.
    static func fetchLandmarks(
        appId: String,
        apiKey: String
    ) async -> [Landmark] {

        guard let url = URL(string: "https://parseapi.back4app.com/classes/Landmark") else {
            return []
        }

        var request = URLRequest(url: url)
        request.addValue(appId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try JSONDecoder().decode(ParseResults.self, from: data)
            return decoded.results
        } catch {
            print("Failed to fetch landmarks:", error)
            return []
        }
    }

    /// Matches Back4App's standard Parse response structure.
    private struct ParseResults: Decodable {
        let results: [Landmark]
    }
}
