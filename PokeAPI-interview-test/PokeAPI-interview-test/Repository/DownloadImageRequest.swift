//
//  DownloadImageRequest.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import Foundation

struct DownloadImageRequest: RequestType {
    var baseURL: URL { imageURL }
    var path: String { "" }
    var queryItems: [URLQueryItem] = []
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var body: Data? { nil }
    
    let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
}
