//
//  PokemonViewModelFactory.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/22.
//

import Foundation

struct PokemonViewModelFactory {
    @MainActor
    static func make() -> PokemonViewModel {
        let client = URLSessionHTTPClient(session: .shared)
        let repo = PokemonRemoteRepository(client: client)
        let useCase = PokemonUseCase(repository: repo)
        let viewModel = PokemonViewModel(useCase: useCase)
        return viewModel
    }
}
