//
//  Defaults.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 11.10.21.
//

import Foundation

enum Defaults {
    enum URL {
        enum Weibo {
            // domains
            static let host = "https://m.weibo.cn"
            static let index = "/api/container/getIndex"
        }
        
        enum Character {
            static let host = "https://cdn.jsdelivr.net"
            static let path = "/gh/godofhuaye/arknight-assets@master/cg"
        }
    }
    
    enum UID {
        enum Weibo {
            static let arknights = "6279793937"
        }
    }
    
    enum Cache: String {
        case Message = "MessageCache.json"
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

extension Defaults.URL.Character {
    static func avatar(of name: String) -> URL? {
        let url = URL(string: host)?
            .appendingPathComponent(path, isDirectory: true)
            .appendingPathComponent(name, isDirectory: true)
            .appendingPathComponent("\(name).png", isDirectory: false)
        return url
    }
}
