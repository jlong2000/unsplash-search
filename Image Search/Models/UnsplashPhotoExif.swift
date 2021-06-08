//
//  UnsplashPhotoExif.swift
//  Image Search
//
//  Created by Jiang Long on 6/4/21.
//

import Foundation

/// A struct representing exif informations of a photo from the Unsplash API.
public struct UnsplashPhotoExif: Codable {

    public let aperture: String
    public let exposureTime: String
    public let focalLength: String
    public let iso: String
    public let make: String
    public let model: String

    private enum CodingKeys: String, CodingKey {
        case aperture
        case exposureTime = "exposure_time"
        case focalLength = "focal_length"
        case iso
        case make
        case model
    }

}
