//
//  Thumbnail.swift
//  
//
//  Created by YaYa2019 on 2023/3/16.
//

import Foundation

public struct Thumbnail: Codable {
    public let url: String?
    public let width: Int?
    public let height: Int?

    enum CodingKeys: CodingKey {
        case url
        case width
        case height
    }

    public init(url: String?, width: Int?, height: Int?) {
        self.url = url
        self.width = width
        self.height = height
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.width = try container.decodeIfPresent(Int.self, forKey: .width)
        self.height = try container.decodeIfPresent(Int.self, forKey: .height)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.url, forKey: .url)
        try container.encodeIfPresent(self.width, forKey: .width)
        try container.encodeIfPresent(self.height, forKey: .height)
    }
}
