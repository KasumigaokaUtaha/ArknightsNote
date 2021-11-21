//
//  Agent.swift
//  ArknightsNote
//
//  Created by Kasumigaoka Utaha on 21.11.21.
//

import Combine
import Foundation

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func mapAppError(_ error: Error) -> AppError {
        switch error {
        case is URLError:
            return .requestError
        case is DecodingError:
            return .parseError
        default:
            return error as? AppError ?? .unknown
        }
    }
    
    func get(request: URLRequest) -> AnyPublisher<Response<Data>, AppError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { element -> Response<Data> in
                guard let httpResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return Response(value: element.data, response: element.response)
            }
            .mapError(mapAppError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func get<T: Decodable>(request: URLRequest, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, AppError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { element -> Response<T> in
                guard let httpResponse = element.response as? HTTPURLResponse,
                        httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                let value = try decoder.decode(T.self, from: element.data)
                return Response(value: value, response: element.response)
            }
            .mapError(mapAppError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
