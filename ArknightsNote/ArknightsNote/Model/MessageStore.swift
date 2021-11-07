//
//  MessageStore.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Foundation
import Kanna

protocol Message {
    var date: Date? { get set }
    var profile: Data { get set }
    var content: String { get set }
    var username: String { get set }
    var platform: String { get set }
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
    var cachedMessages = [Message]()

    func fetchMessages(of platform: Platform, for user: String, completionHandler: @escaping ([Message]?) -> Void) {
        switch platform {
        case .Weibo:
            var messages: [Message]?

            // TODO:
            // Load locally cached messages and merge these messages with
            // new messages fetched via network requests
            WeiboService.shared.getIndexData(uid: user) { data, error in
                guard error == nil else {
                    print("\(error!)")
                    logger.debug("\(error!)", metadata: nil, source: "MessageStore.fetchMessage(of:for)")
                    completionHandler(messages)
                    return
                }
                
                if let indexData = data {
                    let username = indexData.data.userInfo.screenName
                    let profileImageURL = indexData.data.userInfo.profileImageURL
                    let containerId = indexData.data.tabsInfo.tabs
                        .filter({ $0.tabType == "weibo" })
                        .map({ $0.containerId })
                        .first
                    guard let containerId = containerId else {
                        logger.debug("containerId of user \(user) does not exist", metadata: nil, source: ("MessageStore.fetchMessage(of:for)"))
                        completionHandler(messages)
                        return
                    }
                    
                    Network.downloadTask(with: URL(string: profileImageURL)!) { profileData, error in
                        guard error == nil else {
                            print("\(error!)")
                            logger.debug("\(error!)", metadata: nil, source: "MessageStore.fetchMessage(of:for)")
                            completionHandler(messages)
                            return
                        }
                        
                        if let profileData = profileData {
                            WeiboService.shared.getContainerData(uid: user, containerId: containerId) { data, error in
                                guard error == nil else {
                                    print("\(error!)")
                                    logger.debug("\(error!)", metadata: nil, source: "MessageStore.fetchMessage(of:for)")
                                    completionHandler(messages)
                                    return
                                }
                                
                                if let containerData = data {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
                                    let mblogs = containerData.data.cards
                                        .filter({ $0.cardType == 9 })
                                        .map({ $0.mBlog})
                                    messages = mblogs
                                        .map({ WeiboMessage(
                                            date: dateFormatter.date(from: $0.createdAt),
                                            profile: profileData,
                                            content: extractText(
                                                from: $0.text.replacingOccurrences(of: "<br />", with: "\n")
                                            ) ?? "",
                                            username: username,
                                            platform: "微博"
                                        ) })
                                    completionHandler(messages)
                                    // TODO
                                    // process extract text from message.content which is in form of HTML
                                    // see SwiftSoup or Kanna
                                }
                            }
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
