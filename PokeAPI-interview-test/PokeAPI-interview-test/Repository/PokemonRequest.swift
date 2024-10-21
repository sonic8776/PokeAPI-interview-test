//
//  PokemonRequest.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import Foundation

struct PokemonRequest: RequestType {
    var baseURL: URL { .init(string: "https://pokeapi.co/api/v2/pokemon")! }
    var path: String { "/\(name)" }
    var queryItems: [URLQueryItem] = []
    var method: HTTPMethod { .get }
    var headers: [String : String]? { nil }
    var body: Data? { nil }
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
}
