//
//  Defaults.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Foundation

struct Defaults {
    struct URL {
        struct Weibo {
            // domains
            static let host = "https://m.weibo.cn"
            static let index = "/api/container/getIndex"
        }
    }
    
    struct UID {
        struct Weibo {
            static let arknights = "6279793937"
        }
    }
}

extension Defaults.URL {
    static func merge(base: String, params: [String : Any]) -> String {
        let queries = params.map({
            [$0.key, String.init(describing: $0.value)].joined(separator: "=")
        }).joined(separator: "&")
        return [base, queries].joined(separator: "?")
    }
}

extension Defaults.URL.Weibo {
    static func home(uid: String) -> String {
        return Defaults.URL.merge(base: host + index, params: [
            "type": "uid",
            "value": uid
        ])
    }
    static func mblogs(uid: String, containerId: String) -> String {
        return Defaults.URL.merge(base: host + index, params: [
            "type": "uid",
            "value": uid,
            "containerid": containerId
        ])
    }
}
