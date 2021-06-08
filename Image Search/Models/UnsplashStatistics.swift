//
//  UnsplashStatistics.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

/// A struct representing a photo's statistics from the Unsplash API.
public struct UnsplashStatistics: Codable {

    public let identifier: String
    public let views: UnsplashStatisticsElement
    public let downloads: UnsplashStatisticsElement
    public let likes: UnsplashStatisticsElement

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case views
        case downloads
        case likes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        views = try container.decode(UnsplashStatisticsElement.self, forKey: .views)
        downloads = try container.decode(UnsplashStatisticsElement.self, forKey: .downloads)
        likes = try container.decode(UnsplashStatisticsElement.self, forKey: .likes)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(views, forKey: .views)
        try container.encode(downloads, forKey: .downloads)
        try container.encode(likes, forKey: .likes)
    }
}
