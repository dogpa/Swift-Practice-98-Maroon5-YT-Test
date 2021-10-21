//
//  YT JSON.swift
//  Swift Practice # 98 Maroon5 YT Test
//
//  Created by Dogpa's MBAir M1 on 2021/10/21.
//

import Foundation


//解析影片資訊的ＪＳＯＮ
struct YTVideoJSON : Codable {
    let kind: String
    let etag: String
    let nextPageToken: String
    
    let items: [Items]

    struct Items: Codable {
        let kind: String
        let etag: String
        let snippet: Snippet
        let contentDetails: ContentDetails
        struct Snippet: Codable {
            let publishedAt: Date           //發佈日期
            let title: String               //影片標題
            let thumbnails: Thumbnails      //影片縮圖
            let resourceId: ResourceId      //影片watch?v=後接的網址資料
            struct Thumbnails:Codable {
                let high: High
                struct High: Codable {
                    let url: URL
                }
            }
            struct ResourceId: Codable {
                let videoId: String         //影片watch?v=後接的網址資料
            }
        
        }

        struct ContentDetails: Codable {
            let videoId: String             //影片watch?v=後接的網址資料
        }
        
    }
}

//解析頻道的ＪＳＯＮ
struct YtFrontPageJSON : Codable {
    let items: [Items]
    struct Items: Codable {
        let snippet: Snippet
        let statistics: Statistics
        let brandingSettings: BrandingSettings
        
        struct Snippet:Codable {
            let title: String               //頻道標題
            let description: String         //頻道介紹
            let thumbnails: Thumbnails
            
            struct Thumbnails: Codable {
                let high: High
                struct High : Codable {
                    let url: URL            //大頭貼縮圖
                }
            }
        }
        
        struct Statistics:Codable {
            let viewCount: String           //總觀看
            let subscriberCount: String     //訂閱人數
            let videoCount: String          //影片總數
        }
        
        struct BrandingSettings:Codable {
            let image: Image
            struct Image:Codable {
                let bannerExternalUrl: URL  //封面照片
            }
        }
    }
}
