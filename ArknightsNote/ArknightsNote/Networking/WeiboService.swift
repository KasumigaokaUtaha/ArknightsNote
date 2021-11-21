//
//  WeiboService.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 13.10.21.
//

import Combine
import Foundation

struct WeiboService {
    static let shared = WeiboService()

    let agent = Agent()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
        return formatter
    }()
    
    func indexDataRequest(uid: String) -> AnyPublisher<Agent.Response<WeiboIndex>, AppError> {
        guard let url = URL(string: Defaults.URL.Weibo.home(uid: uid)) else {
            return Fail(outputType: Agent.Response<WeiboIndex>.self, failure: AppError.requestError)
                .eraseToAnyPublisher()
        }
        
        return agent.get(request: URLRequest(url: url))
    }
    
    func profileImageDataRequest(url: String) -> AnyPublisher<Agent.Response<Data>, AppError> {
        guard let url = URL(string: url) else {
            return Fail(outputType: Agent.Response<Data>.self, failure: AppError.requestError)
                .eraseToAnyPublisher()
        }
        return agent.get(request: URLRequest(url: url))
    }
    
    func containerDataRequest(uid: String, containerId: String) -> AnyPublisher<Agent.Response<WeiboContainerIndex>, AppError> {
        guard let url = URL(string: Defaults.URL.Weibo.mblogs(uid: uid, containerId: containerId)) else {
            return Fail(outputType: Agent.Response<WeiboContainerIndex>.self, failure: AppError.requestError)
                .eraseToAnyPublisher()
        }
        
        return agent.get(request: URLRequest(url: url))
    }
    
    func messageDataRequest(uid: String) -> AnyPublisher<[Message], AppError> {
        let messagePublisher = indexDataRequest(uid: uid)
            .tryMap { element throws -> (String, String, String) in
                let data = element.value.data
                let userInfo = data.userInfo
                let userName = userInfo.screenName
                let profileImageURL = userInfo.profileImageURL
                let containerId = data.tabsInfo.tabs
                    .filter({ $0.tabType == "weibo" })
                    .map({ $0.containerId })
                    .first
                guard let containerId = containerId else {
                    // TODO: Add debug log
                    throw AppError.parseError
                }
                return (userName, containerId, profileImageURL)
            }
            .mapError({ $0 as! AppError })
            .flatMap { element -> Publishers.Zip3<
                    Result<String, AppError>.Publisher,
                    AnyPublisher<Agent.Response<Data>, AppError>,
                    AnyPublisher<Agent.Response<WeiboContainerIndex>, AppError>
                > in
                let (userName, containerId, imageURL) = element
                let imagePublisher = profileImageDataRequest(url: imageURL)
                let containerDataPublisher = containerDataRequest(uid: uid, containerId: containerId)
                let info: Result<String, AppError> = .success(userName)
                return Publishers.Zip3(
                    info.publisher,
                    imagePublisher,
                    containerDataPublisher
                )
            }
            .map { element -> [Message] in
                let (userName, imageData, containerData) = element
                let mBlogs = containerData.value.data.cards
                    .filter({ $0.cardType == 9 })
                    .map({ $0.mBlog })
                let messages = mBlogs
                    .map { mBlog -> Message in
                        let date = dateFormatter.date(from: mBlog.createdAt)!
                        let content = Util.extractText(from: mBlog.text.replacingOccurrences(of: "<br />", with: "\n")) ?? ""
                        let message = Message(date: date, profile: imageData.value, content: content, username: userName, platform: "微博")
                        return message
                    }
                return messages
            }
            .eraseToAnyPublisher()
        return messagePublisher
    }
}
