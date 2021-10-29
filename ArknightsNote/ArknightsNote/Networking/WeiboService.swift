//
//  WeiboService.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 13.10.21.
//

import Foundation

struct WeiboService {
    static let shared = WeiboService()
    
    func getIndexData(uid: String, completionHandler: @escaping (WeiboIndex?, NetworkError?) -> Void) {
        guard let url = URL(string: Defaults.URL.Weibo.home(uid: uid)) else {
            completionHandler(nil, .requestError)
            return
        }

        Network.dataTask(with: url, type: WeiboIndex.self) { data, error in
//            guard let index = data, error == nil else {
//                logger.debug("\(error!)", metadata: nil, source: "WeiboService.getIndexData(uid:completionHandler)")
//                return
//            }
//            let userName = index.data.userInfo.screenName
//            let containerId = index.data.tabsInfo.tabs
//                .filter({ $0.tabType == "weibo" })
//                .map({ $0.containerId })
//                .first
            completionHandler(data, error)
        }
    }
    
    func getContainerData(uid: String, containerId: String, completionHandler: @escaping (WeiboContainerIndex?, NetworkError?) -> Void) {
        guard let url = URL(string: Defaults.URL.Weibo.mblogs(uid: uid, containerId: containerId)) else {
            completionHandler(nil, .requestError)
            return
        }
        
        Network.dataTask(with: url, type: WeiboContainerIndex.self) { data, error in
//            guard let containerData = data, error == nil else {
//                logger.debug("\(error)", metadata: nil, source: "WeiboService.getContainerData(uid:containerId:completionHandler)")
//                return
//            }
//            let messages = containerData.cards.map({ $0.mBlog.text })
            completionHandler(data, error)
        }
    }
}
