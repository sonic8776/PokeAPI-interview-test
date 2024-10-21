//
//  URLSessionHTTPClient.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/18.
//

import Foundation
import Combine

final class URLSessionHTTPClient: HTTPClient {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    // Using Combine
    func request(with requestType: RequestType) -> AnyPublisher<(Data, HTTPURLResponse), HTTPClientError> {
        return session.dataTaskPublisher(for: requestType.urlRequest)
            .mapError { _ in HTTPClientError.networkError }
            .flatMap { (data, response) -> AnyPublisher<(Data, HTTPURLResponse), HTTPClientError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: HTTPClientError.cannotFindDataOrResponse)
                        .eraseToAnyPublisher()
                }
                
                guard response.statusCode == 200 else {
                    return Fail(error: HTTPClientError.invalidStatusCode(response.statusCode))
                        .eraseToAnyPublisher()
                }
                
                return Just((data, response))
                    .setFailureType(to: HTTPClientError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // Not using Combine
    func request(with requestType: RequestType, completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> ()) {
        session.dataTask(with: requestType.urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
                return
            }
            
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let data
            else {
                completion(.failure(.cannotFindDataOrResponse))
                return
            }
            
            completion(.success((data, response)))
            
        }.resume()
    }
}
