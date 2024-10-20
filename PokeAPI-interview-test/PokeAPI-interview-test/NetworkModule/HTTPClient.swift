//
//  HTTPClient.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/18.
//

import Foundation
import Combine

enum HTTPClientError: Error {
    case networkError
    case cannotFindDataOrResponse
    case invalidStatusCode(Int)
}

protocol HTTPClient {
    func request(with requestType: RequestType) -> AnyPublisher<(Data, HTTPURLResponse), HTTPClientError>
    func request(with requestType: RequestType, completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void)
}

// MARK: - Convenience Extensions
extension HTTPClient {
    func requestJSON<T: Decodable>(with requestType: RequestType,
                                   type: T.Type,
                                   decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return request(with: requestType)
            .map { (data, _) in data }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
