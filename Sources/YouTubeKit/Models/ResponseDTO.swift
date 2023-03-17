//
//  ResponseDTO.swift
//  
//
//  Created by YaYa2019 on 2023/3/17.
//

import Foundation

struct YTResponse: Decodable {
    let contents: Contents?
    let onResponseReceivedCommands: [ResponseReceivedCommand]?

    struct Contents: Decodable {
        let twoColumnSearchResultsRenderer: TwoColumnSearchResultsRenderer?
        let tabs: [Tab]?
        struct TwoColumnSearchResultsRenderer: Decodable {
            let primaryContents: PrimaryContents?

            struct PrimaryContents: Decodable {
                let sectionListRenderer: SectionListRenderer?
            }
        }

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

    struct ResponseReceivedCommand: Decodable {
        let appendContinuationItemsAction: AppendContinuationItemsAction?

        struct AppendContinuationItemsAction: Decodable {
            let continuationItems: [SectionListRenderer.Content]?
        }
    }
}

struct SectionListRenderer: Decodable {
    let contents: [Content]?

    struct Content: Decodable {
        let itemSectionRenderer: ItemSectionRenderer?
        let continuationItemRenderer: ContinuationItemRenderer?
    }
}

struct ItemSectionRenderer: Decodable {
    let contents: [Content]?
    struct Content: Decodable {
        let videoRenderer: VideoRenderer?
        let playlistRenderer: PlaylistRenderer?
    }
}

struct LongBylineText: Decodable {
    let runs: [Run]?
    struct Run: Decodable {
        let text: String?
    }
}

struct VideoRenderer: Decodable {
    let videoId: String?
    let thumbnail: ThumbnailDTO?
    let title: Title?
    let longBylineText: LongBylineText?

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

struct PlaylistRenderer: Decodable {
    let playlistId: String?
    let thumbnails: [ThumbnailDTO]?
    let title: Title?
    let videoCount: String?
    let longBylineText: LongBylineText?

    struct ThumbnailDTO: Decodable {
        let thumbnails: [Thumbnail]?
    }

    struct Title: Decodable {
        let simpleText: String?
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
