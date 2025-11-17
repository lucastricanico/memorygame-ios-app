//
//  Landmark.swift
//  MemoryGame
//
//  Created by Lucas Lopez.
//

import Foundation

/// Represents a landmark item fetched from Back4App.
/// Includes the landmark name and a pointer to a hosted image file.
struct Landmark: Decodable, Identifiable {
    let id: String
    let name: String
    let imageURL: URL

    enum CodingKeys: String, CodingKey {
        case id = "objectId"
        case name
        case image
    }

    enum ImageKeys: String, CodingKey {
        case url
    }

    /// Custom decoding because Back4App file objects wrap their URL.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let imageContainer = try container.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
        imageURL = try imageContainer.decode(URL.self, forKey: .url)
    }
}
