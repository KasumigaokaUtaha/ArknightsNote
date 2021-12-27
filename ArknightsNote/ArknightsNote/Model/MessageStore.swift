//
//  MessageStore.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Combine
import Foundation
import Kanna

struct Message: Codable {
    var date: Date
    var profile: Data
    var content: String
    var username: String
    var platform: String
    var detailLink: String
}

enum Platform {
    case weibo
    case bilibili
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
        messageCache = MessageCache()
        loadCachedMessages()
    }

    func loadCachedMessages() {
        do {
            let messages: [Message] = try FileHelper.loadJSON(
                from: .documentDirectory,
                fileName: Defaults.Cache.message.rawValue
            )
            messageCache.setElements(messages)
        } catch {
            logger.debug("\(error.localizedDescription)", metadata: nil, source: "\(#file).\(#function)")
        }
    }

    func fetchMessages(of platform: Platform, for user: String) {
        switch platform {
        case .weibo:
            let token = SubscriptionToken()
            let messagePublisher = WeiboService.shared.messageDataRequest(uid: user)
            messagePublisher
                .sink(receiveCompletion: { _ in
                    token.unseal() // break the reference cycle here
                }, receiveValue: { messages in
                    messageCache.merge(with: messages, sortBy: { $0.date > $1.date })
                })
                .seal(in: token)

        case .bilibili:
            return
        }
    }
}
