//
//  RequestType.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/18.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol RequestType {
    var baseURL: URL { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get set }
    var fullURL: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var urlRequest: URLRequest { get }
}

extension RequestType {
    var fullURL: URL {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path += path
        components?.queryItems = queryItems
        guard let url = components?.url else {
            fatalError("Invalid URL components: \(String(describing: components))")
        }
        return url
    }
    
    var urlRequest: URLRequest {
        var request = URLRequest(url: fullURL)
        request.httpMethod = method.rawValue
        request.httpBody = body
        if let headers {
            for (headerField, headerValue) in headers{
                request.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        return request
    }
}
