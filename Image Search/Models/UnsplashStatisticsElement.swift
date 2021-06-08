//
//  UnsplashStatisticsElement.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

/// A struct representing a photo's statistics from the Unsplash API.
public struct UnsplashStatisticsElement: Codable {

    public let total: Int
    public let history: UnsplashStatisticsHistory

    private enum CodingKeys: String, CodingKey {
        case total
        case history = "historical"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        total = try container.decode(Int.self, forKey: .total)
        history = try container.decode(UnsplashStatisticsHistory.self, forKey: .history)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(total, forKey: .total)
        try container.encode(history, forKey: .history)
    }
}
