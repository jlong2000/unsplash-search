//
//  GetPhotoStatisticsRequest.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

class GetPhotoStatisticsRequest: UnsplashRequest {

    private let id: String
    var statistics: UnsplashStatistics?

    init(id: String) {
        self.id = id
        super.init()
    }

    // MARK: - Prepare the request

    override var endpoint: String {
        return "/photos/\(id)/statistics"
    }

    // MARK: - Process the response

    override func processJSONResponse() {
        if let statistics = statisticsFromJSONResponse() {
            self.statistics = statistics
        }
        super.processJSONResponse()
    }

    func statisticsFromJSONResponse() -> UnsplashStatistics? {
        guard let jsonResponse = jsonResponse else {
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: jsonResponse, options: [])
            return try JSONDecoder().decode(UnsplashStatistics.self, from: data)
        } catch {
            self.error = error
        }
        return nil
    }
}
