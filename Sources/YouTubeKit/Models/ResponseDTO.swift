//
//  ResponseDTO.swift
//  
//
//  Created by YaYa2019 on 2023/3/17.
//

import Foundation

struct YTResponse: Decodable {
    let contents: Contents?
    let onResponseReceivedActions: [onResponseReceivedAction]?
    
    struct Contents: Decodable {
        let twoColumnBrowseResultsRenderer: TwoColumnBrowseResultsRenderer?
        
        struct TwoColumnBrowseResultsRenderer: Decodable {
            
            let tabs: [Tab]?
            
            struct Tab: Decodable {
                let tabRenderer: TabRenderer?

                struct TabRenderer: Decodable {
                    let content: Content?

                    struct Content: Decodable {
                        let sectionListRenderer: SectionListRenderer?
                    }
                }
            }
        }
    }
    
    struct onResponseReceivedAction: Decodable {
        let appendContinuationItemsAction: AppendContinuationItemsAction?

        struct AppendContinuationItemsAction: Decodable {
            let continuationItems: [PlaylistVideoListRenderer.Content]?
        }
    }
}

struct SectionListRenderer: Decodable {
    let contents: [Content]?

    struct Content: Decodable {
        let itemSectionRenderer: ItemSectionRenderer?
    }
}

struct ItemSectionRenderer: Decodable {
    let contents: [Content]?
    struct Content: Decodable {
        let playlistVideoListRenderer: PlaylistVideoListRenderer?
    }
}

struct PlaylistVideoListRenderer: Decodable {
    let contents: [Content]?
    struct Content: Decodable {
        let playlistVideoRenderer: PlaylistVideoRenderer?
        let continuationItemRenderer: ContinuationItemRenderer?
    }
}

struct ShortBylineText: Decodable {
    let runs: [Run]?
    struct Run: Decodable {
        let text: String?
    }
}

struct PlaylistVideoRenderer: Decodable {
    let videoId: String?
    let thumbnail: ThumbnailDTO?
    let title: Title?
    let shortBylineText: ShortBylineText?

    struct ThumbnailDTO: Decodable {
        let thumbnails: [Thumbnail]?
    }

    struct Title: Decodable {
        let runs: [Run]?
        struct Run: Decodable {
            let text: String?
        }
    }
}

struct ContinuationItemRenderer: Decodable {
    let continuationEndpoint: ContinuationEndpoint?
    struct ContinuationEndpoint: Decodable {
        let continuationCommand: ContinuationCommand?
        struct ContinuationCommand: Decodable {
            let token: String?
            let request: String?
        }
    }
}
