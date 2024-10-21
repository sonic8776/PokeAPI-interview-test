//
//  PokemonUseCase.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import Foundation
import Combine

enum PokemonUseCaseError: LocalizedError {
    case repositoryError(PokemonRemoteRepositoryError)
    case invalidPokemonData
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .repositoryError(let error):
            return "Repository error: \(error)"
        case .invalidPokemonData:
            return "Invalid pokemon data received"
        case .emptyName:
            return "Pokemon name cannot be empty"
        }
    }
}

protocol PokemonUseCaseProtocol {
    func getPokemon(withName name: String) -> AnyPublisher<PokemonDomainModel, PokemonUseCaseError>
    func getImage(fromURL url: URL) -> AnyPublisher<Data, PokemonUseCaseError>
}

final class PokemonUseCase: PokemonUseCaseProtocol {
    
    private let repository: PokemonRemoteRepositoryProtocol
    
    init(repository: PokemonRemoteRepositoryProtocol) {
        self.repository = repository
    }
    
    func getPokemon(withName name: String) -> AnyPublisher<PokemonDomainModel, PokemonUseCaseError> {
        // Input validation
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return Fail(error: PokemonUseCaseError.emptyName)
                .eraseToAnyPublisher()
        }
        
        return repository.requestPokemon(withName: name)
            .mapError({ PokemonUseCaseError.repositoryError($0) })
            .map { dto -> PokemonDomainModel in
                return PokemonDomainModel(fromDTO: dto)
            }
            .tryMap { domain -> PokemonDomainModel in
                // Additional business validation if needed
                guard domain.id > 0 else {
                    throw PokemonUseCaseError.invalidPokemonData
                }
                return domain
            }
            .mapError { error -> PokemonUseCaseError in
                if let useCaseError = error as? PokemonUseCaseError {
                    return useCaseError
                }
                return .invalidPokemonData
            }
            .eraseToAnyPublisher()
    }
    
    func getImage(fromURL url: URL) -> AnyPublisher<Data, PokemonUseCaseError> {
        return repository.downloadImage(fromURL: url)
            .mapError { PokemonUseCaseError.repositoryError($0) }
            .eraseToAnyPublisher()
    }
}
