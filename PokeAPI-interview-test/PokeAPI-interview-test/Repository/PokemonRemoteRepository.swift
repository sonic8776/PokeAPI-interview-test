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
        
        return client.requestJSON(with: pokemonRequest, type: PokemonDTO.self)
            .mapError { [weak self] error -> PokemonRemoteRepositoryError in
                self?.handleError(error) ?? .networkError
            }
            .eraseToAnyPublisher()
    }
    
    func downloadImage(fromURL url: URL) -> AnyPublisher<Data, PokemonRemoteRepositoryError> {
        let imageDownloadRequest = DownloadImageRequest(imageURL: url)
        return client.request(with: imageDownloadRequest)
            .map { data, _ in data }
            .mapError { [weak self] error -> PokemonRemoteRepositoryError in
                self?.handleError(error) ?? .networkError
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Helper methods

private extension PokemonRemoteRepository {
    func handleError(_ error: Error) -> PokemonRemoteRepositoryError {
        print("Error: \(error)")
        switch error {
        case is DecodingError:
            return .failedToParseData
        case let httpError as HTTPClientError:
            return mapHTTPError(httpError)
        default:
            return .networkError
        }
    }
    
    func mapHTTPError(_ error: HTTPClientError) -> PokemonRemoteRepositoryError {
        switch error {
        case .networkError:
            return .networkError
        case .cannotFindDataOrResponse:
            return .failedToParseData
        case .invalidStatusCode(let code):
            return .invalidStatusCode(code)
        }
    }
}
