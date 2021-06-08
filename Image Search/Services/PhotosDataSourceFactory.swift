//
//  PhotosDataSourceFactory.swift
//  Image Search
//
//  Created by Jiang Long on 6/6/21.
//

import UIKit

enum PhotosDataSourceFactory: PagedDataSourceFactory {
    case search(query: String)
    case collection(identifier: String)

    var dataSource: PagedDataSource {
        return PagedDataSource(with: self)
    }

    func initialCursor() -> UnsplashPagedRequest.Cursor {
        switch self {
        case .search(let query):
            return SearchPhotosRequest.cursor(with: query, page: 1, perPage: 30)
        case .collection(let identifier):
            let perPage = 30
            return GetCollectionPhotosRequest.cursor(with: identifier, page: 1, perPage: perPage)
        }
    }

    func request(with cursor: UnsplashPagedRequest.Cursor) -> UnsplashPagedRequest {
        switch self {
        case .search(let query):
            return SearchPhotosRequest(with: query, page: cursor.page, perPage: cursor.perPage)
        case .collection(let identifier):
            return GetCollectionPhotosRequest(for: identifier, page: cursor.page, perPage: cursor.perPage)
        }
    }
}
