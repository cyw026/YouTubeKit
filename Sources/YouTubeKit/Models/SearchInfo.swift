//
//  SearchInfo.swift
//  
//
//  Created by YaYa2019 on 2023/3/16.
//

import Foundation

public struct SearchInfo: Codable {

    public let searchString: String?
    public var continuation: String?
    public let contentFilter: String?
    public let sortFilter: String?

    public var relatedItems: [InfoItem]?
}
