//
//  GetCollectionPhotosRequest.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import Foundation

class GetCollectionPhotosRequest: UnsplashPagedRequest {

    static func cursor(with collectionId: String, page: Int = 1, perPage: Int = 10) -> UnsplashPagedRequest.Cursor {
        let parameters: [String: Any] = ["id": collectionId]
        return Cursor(page: page, perPage: perPage, parameters: parameters)
    }

    convenience init(for collectionId: String, page: Int = 1, perPage: Int = 10) {
        let cursor = GetCollectionPhotosRequest.cursor(with: collectionId, page: page, perPage: perPage)
        self.init(with: cursor)
    }

    override init(with cursor: Cursor) {
        if let parameters = cursor.parameters {
            if let collectionId = parameters["id"] as? String {
                self.collectionId = collectionId
            } else {
                self.collectionId = ""
            }
        } else {
            self.collectionId = ""
        }
        super.init(with: cursor)
    }

    private let collectionId: String

    // MARK: - Prepare the request

    override var endpoint: String {
        return "/collections/\(collectionId)/photos"
    }

    override func prepareParameters() -> [String: Any]? {
        var parameters = super.prepareParameters()
        parameters?["id"] = nil
        return parameters
    }

    // MARK: - Process the response

    override func processResponseData(_ data: Data?) {
        if let photos = photosFromResponseData(data) {
            self.items = photos
            completeOperation()
        }
        super.processResponseData(data)
    }

    func photosFromResponseData(_ data: Data?) -> [UnsplashPhoto]? {
        guard let data = data else { return nil }

        do {
            return try JSONDecoder().decode([UnsplashPhoto].self, from: data)
        } catch {
            self.error = error
            return nil
        }
    }

}
