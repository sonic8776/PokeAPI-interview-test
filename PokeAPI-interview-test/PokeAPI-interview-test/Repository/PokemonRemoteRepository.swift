//
//  PokemonRemoteRepository.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import Foundation
import Combine

enum PokemonRemoteRepositoryError: Error {
    case failedToParseData
    case networkError
    case invalidStatusCode(Int)
}

protocol PokemonRemoteRepositoryProtocol {
    func requestPokemon(withName name: String) -> AnyPublisher<PokemonDTO, PokemonRemoteRepositoryError>
    func downloadImage(fromURL url: URL) -> AnyPublisher<Data, PokemonRemoteRepositoryError>
}

final class PokemonRemoteRepository: PokemonRemoteRepositoryProtocol {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func requestPokemon(withName name: String) -> AnyPublisher<PokemonDTO, PokemonRemoteRepositoryError> {
        let pokemonRequest = PokemonRequest(name: name.lowercased())
        
        return client.request(with: pokemonRequest)
            .map { data, _ in data }
            .decode(type: PokemonDTO.self, decoder: JSONDecoder())
            .mapError { error -> PokemonRemoteRepositoryError in
                print("Error: \(error)")
                
                switch error {
                case is DecodingError:
                    return .failedToParseData
                case let httpError as HTTPClientError:
                    switch httpError {
                    case .networkError:
                        return .networkError
                    case .cannotFindDataOrResponse:
                        return .failedToParseData
                    case .invalidStatusCode(let code):
                        return .invalidStatusCode(code)
                    }
                default:
                    return .networkError
                }
            }
            .eraseToAnyPublisher()
    }
    
    func downloadImage(fromURL url: URL) -> AnyPublisher<Data, PokemonRemoteRepositoryError> {
        let imageDownloadRequest = DownloadImageRequest(imageURL: url)
        return client.request(with: imageDownloadRequest)
            .map { data, _ in data }
            .mapError { error -> PokemonRemoteRepositoryError in
                print("Error: \(error)")
                
                switch error {
                case .networkError:
                    return .networkError
                case .cannotFindDataOrResponse:
                    return .failedToParseData
                case .invalidStatusCode(let code):
                    return .invalidStatusCode(code)
                }
            }
            .eraseToAnyPublisher()
    }
}
