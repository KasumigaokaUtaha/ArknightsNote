//
//  MessageStore.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Foundation
import Kanna

struct Message: Codable {
    var date: Date
    var profile: Data
    var content: String
    var username: String
    var platform: String
}

enum Platform {
    case Weibo
    case Bilibili
}

struct MessageStore {
    static let shared = MessageStore()
    
    /// Stores cached messages
    ///
    /// It tries to first load locally cached messages.
    /// When new messages are fetched via network requests, they are merged with existing ones.
    ///
    /// Besides, it automatically saves the cached content in local storage.
    var messageCache: MessageCache

    init() {
        do {
            let messages: [Message] = try FileHelper.loadJSON(from: .documentDirectory, fileName: Defaults.Cache.Message.rawValue)
            messageCache = MessageCache(elements: messages)
        } catch {
            logger.debug("\(error.localizedDescription)", metadata: nil, source: "\(#file).\(#function)")
            messageCache = MessageCache()
        }
    }
    
    func fetchMessages(of platform: Platform, for user: String, completionHandler: @escaping () -> Void) {
        switch platform {
        case .Weibo:
            WeiboService.shared.getIndexData(uid: user) { data, error in
                guard error == nil else {
                    print("\(error!)")
                    logger.debug("\(error!)", metadata: nil, source: "MessageStore.fetchMessage(of:for)")
                    completionHandler()
                    return
                }
                
                guard let indexData = data else {
                    logger.debug("IndexData is empty", metadata: nil, source: "\(#file).\(#function)")
                    completionHandler()
                    return
                }
                
                let username = indexData.data.userInfo.screenName
                let profileImageURL = indexData.data.userInfo.profileImageURL
                let containerId = indexData.data.tabsInfo.tabs
                    .filter({ $0.tabType == "weibo" })
                    .map({ $0.containerId })
                    .first
                guard let containerId = containerId else {
                    logger.debug("containerId of user \(user) does not exist", metadata: nil, source: ("MessageStore.fetchMessage(of:for)"))
                    completionHandler()
                    return
                }
                
                Network.downloadTask(with: URL(string: profileImageURL)!) { profileData, error in
                    guard error == nil else {
                        print("\(error!)")
                        logger.debug("\(error!)", metadata: nil, source: "MessageStore.fetchMessage(of:for)")
                        completionHandler()
                        return
                    }
                    
                    guard let profileData = profileData else {
                        logger.debug("Profile data is empty", metadata: nil, source: "\(#file).\(#function)")
                        completionHandler()
                        return
                    }
                    
                    WeiboService.shared.getContainerData(uid: user, containerId: containerId) { data, error in
                        guard error == nil else {
                            print("\(error!)")
                            logger.debug("\(error!)", metadata: nil, source: "MessageStore.fetchMessage(of:for)")
                            completionHandler()
                            return
                        }
                        
                        if let containerData = data {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
                            let mblogs = containerData.data.cards
                                .filter({ $0.cardType == 9 })
                                .map({ $0.mBlog})
                            let messages = mblogs
                                .map({ Message(
                                    date: dateFormatter.date(from: $0.createdAt)!,
                                    profile: profileData,
                                    content: self.extractText(
                                        from: $0.text.replacingOccurrences(of: "<br />", with: "\n")
                                    ) ?? "",
                                    username: username,
                                    platform: "微博"
                                ) })
                            messageCache.merge(with: messages)
                            completionHandler()
                        }
                    }
                }
            }
        case .Bilibili:
            return
        }
    }
    
    private func extractText(from html: String) -> String? {
        return (try? Kanna.HTML(html: html, encoding: .utf8))?.text
    }
}
