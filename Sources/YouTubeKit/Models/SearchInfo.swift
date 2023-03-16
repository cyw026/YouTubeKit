//
//  SearchInfo.swift
//  
//
//  Created by YaYa2019 on 2023/3/16.
//

import Foundation

public class InfoItem: Codable {
    let id: String?
    let title: String?
    let channelTitle: String?

    enum CodingKeys: CodingKey {
        case id
        case title
        case channelTitle
    }

    public init(id: String?, title: String?, channelTitle: String?) {
        self.id = id
        self.title = title
        self.channelTitle = channelTitle
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.channelTitle = try container.decodeIfPresent(String.self, forKey: .channelTitle)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.id, forKey: .id)
        try container.encodeIfPresent(self.title, forKey: .title)
        try container.encodeIfPresent(self.channelTitle, forKey: .channelTitle)
    }

    public func jsonString() -> String {
        guard let jsonData = try? JSONEncoder().encode(self) else { return "" }
        return String(data:jsonData, encoding:.utf8) ?? ""
    }
}

public class VideoInfoItem: InfoItem {
    var medium: Thumbnail?
    var high: Thumbnail?

    enum CodingKeys: CodingKey {
        case medium
        case high
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try super.init(from: decoder)
        self.medium = try? container.decode(Thumbnail.self, forKey: .medium)
        self.high = try? container.decode(Thumbnail.self, forKey: .high)
    }

    public init(id: String?, title: String?, channelTitle: String?, medium: Thumbnail?, high: Thumbnail?) {
        super.init(id: id, title: title, channelTitle: channelTitle)
        self.medium = medium
        self.high = high
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)

        try container.encodeIfPresent(self.medium, forKey: .medium)
        try container.encodeIfPresent(self.high, forKey: .high)
    }
}

public class PlaylistInfoItem: InfoItem {
    var coverUrl: String?
    var videoCount: Int?

    enum CodingKeys: CodingKey {
        case videoCount
        case coverUrl
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        try super.init(from: decoder)
        self.videoCount = try container.decodeIfPresent(Int.self, forKey: .videoCount)
        self.coverUrl = try container.decodeIfPresent(String.self, forKey: .coverUrl)
    }

    init(id: String?, title: String?, channelTitle: String?, coverUrl: String?, videoCount: Int?) {
        super.init(id: id, title: title, channelTitle: channelTitle)
        self.coverUrl = coverUrl
        self.videoCount = videoCount
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)

        try container.encodeIfPresent(self.coverUrl, forKey: .coverUrl)
        try container.encodeIfPresent(self.videoCount, forKey: .videoCount)
    }
}

public struct SearchInfo: Codable {

    public let searchString: String?
    public var continuation: String?
    public let contentFilter: String?
    public let sortFilter: String?

    public var relatedItems: [InfoItem]?
}
