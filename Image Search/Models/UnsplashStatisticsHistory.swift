//
//  UnsplashStatisticsHistory.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

/// A struct representing a photo's statistics history from the Unsplash API.
public struct UnsplashStatisticsHistory: Codable {

    public let change: Int
    public let resolution: String
    public let quantity: Int
    public let logs: [UnsplashStatisticsLog]

    private enum CodingKeys: String, CodingKey {
        case change
        case resolution
        case quantity
        case logs = "values"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        change = try container.decode(Int.self, forKey: .change)
        resolution = try container.decode(String.self, forKey: .resolution)
        quantity = try container.decode(Int.self, forKey: .quantity)
        logs = try container.decode([UnsplashStatisticsLog].self, forKey: .logs)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(change, forKey: .change)
        try container.encode(resolution, forKey: .resolution)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(logs, forKey: .logs)
    }
}
