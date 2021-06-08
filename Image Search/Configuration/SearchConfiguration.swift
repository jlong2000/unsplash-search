//
//  SearchConfiguration.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import Foundation

/// Encapsulates configuration information for the behavior of UnsplashPhotoPicker.
public struct SearchConfiguration {

    /// Your application’s access key.
    public var accessKey = ""

    /// Your application’s secret key.
    public var secretKey = ""

    /// A search query. When set, hides the search bar and shows results instead of the editorial photos.
    public var query: String?

    /// The memory capacity used by the cache.
    public var memoryCapacity = defaultMemoryCapacity

    /// The disk capacity used by the cache.
    public var diskCapacity = defaultDiskCapacity

    /// The default memory capacity used by the cache.
    public static let defaultMemoryCapacity: Int = ImageCache.memoryCapacity

    /// The default disk capacity used by the cache.
    public static let defaultDiskCapacity: Int = ImageCache.diskCapacity

    /// The Unsplash API url.
    let apiURL = "https://api.unsplash.com/"

    /// The Unsplash editorial collection id.
    let editorialCollectionId = "317099"

    /**
     Initializes an `SearchConfiguration` object with optionally customizable behaviors.

     - parameter accessKey:               Your application’s access key.
     - parameter secretKey:               Your application’s secret key.
     - parameter query:                   A search query.
     - parameter allowsMultipleSelection: Controls whether the picker allows multiple or single selection.
     - parameter memoryCapacity:          The memory capacity used by the cache.
     - parameter diskCapacity:            The disk capacity used by the cache.
     */
    public init(accessKey: String,
                secretKey: String,
                query: String? = nil,
                memoryCapacity: Int = defaultMemoryCapacity,
                diskCapacity: Int = defaultDiskCapacity) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.query = query
        self.memoryCapacity = memoryCapacity
        self.diskCapacity = diskCapacity
    }

    init() {}

}
