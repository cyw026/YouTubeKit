//
//  PlaylistInfo.swift
//  
//
//  Created by YaYa2019 on 2023/3/17.
//

import Foundation

public struct PlaylistInfo: Codable {
    
    public let playlistId: String?
    public let title: String?
    public let channelTitle: String?
    public var coverUrl: String?
    public var videoCount: Int?

    public var relatedItems: [VideoInfoItem]?

}
