//
//  Network.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 12.10.21.
//

import Foundation

// TODO
// Method that provides basic network request functionality
enum NetworkError {
    case requestError
    case parseError
}

struct Network {
    static func dataTask<T: Decodable>(with url: URL, type: T.Type, completionHandler: @escaping (T?, NetworkError?) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                logger.debug("\(error!)", metadata: nil, source: "Network.dataTask(with:completionHandler:)")
                completionHandler(nil, .parseError)
                return
            }
            
            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(nil, .requestError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                completionHandler(jsonData, nil)
            } catch {
                print("url: \(url)\ntype: \(type)\ndata:\(String(describing: String(data: data, encoding: .utf8)))")
                completionHandler(nil, .parseError)
            }
        }
        
        task.resume()
    }
    
    static func downloadTask(with url: URL, completionHandler: @escaping (Data?, NetworkError?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { url, response, error in
            guard error == nil else {
                completionHandler(nil, .parseError)
                return
            }
            
            guard let dataURL = url, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(nil, .requestError)
                return
            }
            
            do {
                let data = try Data(contentsOf: dataURL)
                completionHandler(data, nil)
            } catch {
                completionHandler(nil, .parseError)
            }
        }
        
        task.resume()
    }
}
// Convenince methods that handle specific network requests, for example
// weibo index request, weibo mblogs request
