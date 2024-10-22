//
//  URLSessionHTTPClient.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/18.
//

import Foundation
import Combine

final class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    private let acceptableStatusCodes = 200...299
    
    init(session: URLSession) {
        self.session = session
    }
    
    // Using Combine
    func request(with requestType: RequestType) -> AnyPublisher<(Data, HTTPURLResponse), HTTPClientError> {
        return session.dataTaskPublisher(for: requestType.urlRequest)
            .tryMap { [weak self] (data, response) -> (Data, HTTPURLResponse) in
                guard let self = self else { throw HTTPClientError.networkError }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPClientError.cannotFindDataOrResponse
                }
                
                guard self.acceptableStatusCodes.contains(httpResponse.statusCode) else {
                    throw HTTPClientError.invalidStatusCode(httpResponse.statusCode)
                }
                
                return (data, httpResponse)
            }
            .mapError { error -> HTTPClientError in
                return HTTPClientError.networkError
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
                self.acceptableStatusCodes.contains(response.statusCode),
                let data
            else {
                completion(.failure(.cannotFindDataOrResponse))
                return
            }
            
            completion(.success((data, response)))
            
        }.resume()
    }
}
