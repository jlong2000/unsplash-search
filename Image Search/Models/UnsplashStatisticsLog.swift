//
//  UnsplashStatisticsLog.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

public struct UnsplashStatisticsLog: Codable {
    public let date: String
    public let value: Int

    private enum CodingKeys: String, CodingKey {
        case date
        case value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        value = try container.decode(Int.self, forKey: .value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(value, forKey: .value)
    }
}
