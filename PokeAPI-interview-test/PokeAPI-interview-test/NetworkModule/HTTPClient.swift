//
//  HTTPClient.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/18.
//

import Foundation

enum HTTPClientError: Error {
    case networkError
    case cannotFindDataOrResponse
}

protocol HTTPClient {
    func request(with requestType: RequestType, completion: @escaping (Result<(Data, HTTPURLResponse), HTTPClientError>) -> Void)
}
