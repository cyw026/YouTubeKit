//
//  PlaylistInfo.swift
//  
//
//  Created by YaYa2019 on 2023/3/17.
//

import Foundation

public struct PlaylistInfo: Codable {
    
    public let playlistId: String?
    public var title: String?
    public var channelTitle: String?
    public var coverUrl: String?
    public var videoCount: Int?

    public var relatedItems: [VideoInfoItem]?
    
    public var continuation: String?

}
