//
//  ImageCache.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import UIKit

class ImageCache {

    static let cache: URLCache = {
        let diskPath = "unsplash"

        return URLCache(
            memoryCapacity: Configuration.shared.memoryCapacity,
            diskCapacity: Configuration.shared.diskCapacity,
            directory: URL(fileURLWithPath: diskPath, isDirectory: true)
        )
    }()

    static let memoryCapacity: Int = 50.megabytes
    static let diskCapacity: Int = 100.megabytes

}

private extension Int {
    var megabytes: Int { return self * 1024 * 1024 }
}
