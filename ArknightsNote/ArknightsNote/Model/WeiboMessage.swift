//
//  WeiboMessage.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Foundation

// MARK: - WeiboIndex
struct WeiboIndex: Codable {
    var data: WeiboIndexData
}

struct WeiboIndexData: Codable {
    var scheme: String
    var userInfo: UserInfo
    var tabsInfo: TabsInfo
}

struct UserInfo: Codable {
    var avatarHD: String
    var screenName: String
    var profileImageURL: String

    enum CodingKeys: String, CodingKey {
        case avatarHD = "avatar_hd"
        case screenName = "screen_name"
        case profileImageURL = "profile_image_url"
    }
}

struct TabsInfo: Codable {
    var tabs: [Tab]
}

struct Tab: Codable {
    var tabType: String
    var containerId: String

    enum CodingKeys: String, CodingKey {
        case tabType = "tab_type"
        case containerId = "containerid"
    }
}

// MARK: - WeiboContainerIndex
struct WeiboContainerIndex: Codable {
    var data: WeiboContainerData
}

struct WeiboContainerData: Codable {
    var cards: [WeiboCard]
}

struct WeiboCard: Codable {
    var mBlog: MBlog
    var scheme: String
    var cardType: Int
    
    enum CodingKeys: String, CodingKey {
        case mBlog = "mblog"
        case scheme = "scheme"
        case cardType = "card_type"
    }
}

struct MBlog: Codable {
    var createdAt: String
    var id: String
    var text: String
    var picURL: String?
    var pageInfo: PageInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case picURL = "original_pic"
        case pageInfo = "page_info"
        case createdAt = "created_at"
    }
}

struct PageInfo: Codable {
    var type: String
    var pagePic: PagePic
    var pageURL: String
    
    enum CodingKeys: String, CodingKey {
        case type
        case pagePic = "page_pic"
        case pageURL = "page_url"
    }
}

struct PagePic: Codable {
    var url: String
}
