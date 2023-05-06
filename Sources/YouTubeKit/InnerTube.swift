//
//  InnerTube.swift
//  YouTubeKit
//
//  Created by Alexander Eichhorn on 05.09.21.
//

import Foundation

@available(iOS 13.0, watchOS 6.0, tvOS 13.0, macOS 10.15, *)
class InnerTube {
    
    private struct Client {
        let name: String
        let version: String
        let screen: String?
        let apiKey: String
        let userAgent: String?

        var androidSdkVersion: Int? = nil
        
        var context: Context {
            return Context(client: InnerTube.Context.ContextClient(clientName: name, clientVersion: version, clientScreen: screen, androidSdkVersion: androidSdkVersion))
        }
        
        var headers: [String: String] {
            ["User-Agent": userAgent ?? ""].filter { !$0.value.isEmpty }
        }
    }
    
    private struct Context: Encodable {
        let client: ContextClient
        
        struct ContextClient: Encodable {
            let clientName: String
            let clientVersion: String
            let clientScreen: String?
            let androidSdkVersion: Int?
        }
    }
    
    // overview of clients: https://github.com/zerodytrash/YouTube-Internal-Clients
    private let defaultClients = [
        ClientType.web: Client(name: "WEB", version: "2.20200720.00.02", screen: nil, apiKey: "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8", userAgent: "Mozilla/5.0"),
        ClientType.android: Client(name: "ANDROID", version: "17.31.35", screen: nil, apiKey: "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8", userAgent: "com.google.android.youtube/17.31.35 (Linux; U; Android 11) gzip", androidSdkVersion: 30),
        ClientType.androidMusic: Client(name: "ANDROID_MUSIC", version: "5.16.51", screen: nil, apiKey: "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8", userAgent: "com.google.android.apps.youtube.music/17.31.35 (Linux; U; Android 11) gzip", androidSdkVersion: 30),
        ClientType.webEmbed: Client(name: "WEB_EMBEDDED_PLAYER", version: "1.20220731.00.00", screen: "EMBED", apiKey: "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8", userAgent: "Mozilla/5.0"),
        ClientType.androidEmbed: Client(name: "ANDROID_EMBEDDED_PLAYER", version: "17.31.35", screen: "EMBED", apiKey: "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8", userAgent: "com.google.android.youtube/17.31.35 (Linux; U; Android 11) gzip"),
        ClientType.tvEmbed: Client(name: "TVHTML5_SIMPLY_EMBEDDED_PLAYER", version: "2.0", screen: "EMBED", apiKey: "AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8", userAgent: "Mozilla/5.0")
    ]
    
    enum ClientType {
        case web, android, androidMusic, webEmbed, androidEmbed, tvEmbed
    }
    
    private var accessToken: String?
    private var refreshToken: String?
    
    private let useOAuth: Bool
    private let allowCache: Bool
    
    private let apiKey: String
    private let context: Context
    private let headers: [String: String]
    
    private let baseURL = "https://www.youtube.com/youtubei/v1"
    
    init(client: ClientType = .android, useOAuth: Bool = false, allowCache: Bool = true) {
        self.context = defaultClients[client]!.context
        self.apiKey = defaultClients[client]!.apiKey
        self.headers = defaultClients[client]!.headers
        self.useOAuth = useOAuth
        self.allowCache = allowCache
        
        if useOAuth && allowCache {
            // TODO: load from cache file
        }
    }
    
    func cacheTokens() {
        guard allowCache else { return }
        // TODO: cache access and refresh tokens
    }
    
    func refreshBearerToken(force: Bool = false) {
        guard useOAuth else { return }
        // TODO: implement refresh of access token
    }
    
    func fetchBearerToken() {
        // TODO: fetch tokens
    }
    
    private struct BaseData: Encodable {
        let context: Context
    }
    
    private var baseData: BaseData {
        return BaseData(context: context)
    }
    
    private var baseParams: [URLQueryItem] {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "contentCheckOk", value: "true"),
            URLQueryItem(name: "racyCheckOk", value: "true")
        ]
    }
    
    private func callAPI<D: Encodable, T: Decodable>(endpoint: String, query: [URLQueryItem], object: D) async throws -> T {
        let data = try JSONEncoder().encode(object)
        return try await callAPI(endpoint: endpoint, query: query, data: data)
    }
    
    private func callAPI<T: Decodable>(endpoint: String, query: [URLQueryItem], data: Data) async throws -> T {
        
        // TODO: handle oauth case
        
        var urlComponents = URLComponents(string: endpoint)!
        urlComponents.queryItems = query
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "post"
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
        request.addValue("en-US,en", forHTTPHeaderField: "accept-language")
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // TODO: handle oauth auth case again
        
        let (responseData, _) = try await URLSession.shared.data(for: request)

        let str = String(decoding: responseData, as: UTF8.self)

        print("responseData:", str)
        
        return try JSONDecoder().decode(T.self, from: responseData)
    }
    
    struct VideoInfo: Decodable {
        let playabilityStatus: PlayabilityStatus?
        let streamingData: StreamingData?
        
        struct PlayabilityStatus: Decodable {
            let status: String?
            let reason: String?
        }
    }    
    
    struct StreamingData: Decodable {
        let expiresInSeconds: String?
        let formats: [Format]?
        let adaptiveFormats: [Format]? // actually slightly different Format object (TODO)
        let onesieStreamingUrl: String?
        
        struct Format: Decodable {
            let itag: Int
            var url: String?
            let mimeType: String
            let bitrate: Int
            let width: Int?
            let height: Int?
            let lastModified: String?
            let contentLength: String?
            let quality: String
            let fps: Int?
            let qualityLabel: String?
            let averageBitrate: Int?
            let audioQuality: String?
            let approxDurationMs: String?
            let audioSampleRate: String?
            let audioChannels: Int?
            let signatureCipher: String? // not tested yet
            var s: String? // assigned from Extraction.applyDescrambler
        }
    }

    struct SearchResult: Decodable {
        let contents: Contents?
        let onResponseReceivedCommands: [ResponseReceivedCommand]?

        struct Contents: Decodable {
            let twoColumnSearchResultsRenderer: TwoColumnSearchResultsRenderer?
            struct TwoColumnSearchResultsRenderer: Decodable {
                let primaryContents: PrimaryContents?

                struct PrimaryContents: Decodable {
                    let sectionListRenderer: SectionListRenderer?
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
    
    private struct PlayerRequest: Encodable {
        let context: Context
        let videoId: String
        let params: String = "8AEB"
        //let paybackContext
        let contentCheckOk: Bool = true
        let racyCheckOk: Bool = true
    }
    
    private func playerRequest(forVideoID videoID: String) -> PlayerRequest {
        PlayerRequest(context: context, videoId: videoID)
    }
    
    func player(videoID: String) async throws -> VideoInfo {
        let endpoint = baseURL + "/player"
        let query = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        let request = playerRequest(forVideoID: videoID)
        return try await callAPI(endpoint: endpoint, query: query, object: request)
    }
    
    // TODO: change result type
    func search(query: String, contentFilter: String? = nil, continuation: String? = nil) async throws -> SearchResult {
        
        struct SearchObject: Encodable {
            let context: Context
            let continuation: String?
        }
        
        let query = baseParams + [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "params", value: contentFilter)
        ]

        let object = SearchObject(context: context, continuation: continuation)
        return try await callAPI(endpoint: baseURL + "/search", query: query, object: object)
    }

    func playlistInfo(playlistId: String, continuation: String? = nil) async throws -> YTResponse {

        struct PlaylistRequest: Encodable {
            let context: Context
            let continuation: String?
            
            var browseId: String?
            var params: String?
        }
        let query = [
            URLQueryItem(name: "key", value: apiKey),
        ]

        var object: PlaylistRequest?
        if continuation != nil {
            object = PlaylistRequest(context: context, continuation: continuation)
        } else {
            object = PlaylistRequest(context: context, continuation: continuation, browseId: "VL\(playlistId)", params: "wgYCCAA%3D")
        }
        return try await callAPI(endpoint: baseURL + "/browse?prettyPrint=false", query: query, object: object)
    }
    
    // TODO: change result type
    func verifyAge(videoID: String) async throws -> [String: String] {
        
        struct RequestObject: Encodable {
            let nextEndpoint: NextEndpoint
            let setControvercy: Bool
            let context: Context
            
            struct NextEndpoint: Encodable {
                let urlEndpoint: URLEndpoint
            }
            
            struct URLEndpoint: Encodable {
                let url: String
            }
        }
        
        let object = RequestObject(nextEndpoint: RequestObject.NextEndpoint(urlEndpoint: RequestObject.URLEndpoint(url: "/watch?v=\(videoID)")), setControvercy: true, context: context)
        return try await callAPI(endpoint: baseURL + "/verify_age", query: baseParams, object: object)
    }
    
    // TODO: change result type
    func getTranscript(videoID: String) async throws -> [String: String] {
        let query = baseParams + [
            URLQueryItem(name: "videoID", value: videoID)
        ]
        return try await callAPI(endpoint: baseURL + "/get_transcript", query: query, object: baseData)
    }
    
}
