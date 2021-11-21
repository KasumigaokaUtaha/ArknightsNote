//
//  MessageStore.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Kanna
import Combine
import Foundation

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
            let token = SubscriptionToken()
            let messagePublisher = WeiboService.shared.messageDataRequest(uid: user)
            messagePublisher
                .sink(receiveCompletion: { _ in
//                    print("MessagePublisher completes: \($0)")
                    token.unseal() // break the reference cycle here
                    completionHandler() // TODO check if this is necessary
                }, receiveValue: { messages in
                    messageCache.merge(with: messages)
                    completionHandler()
                })
                .seal(in: token)
            
        case .Bilibili:
            return
        }
    }
    
    private func extractText(from html: String) -> String? {
        return (try? Kanna.HTML(html: html, encoding: .utf8))?.text
    }
}
