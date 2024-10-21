//
//  PokemonViewModel.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import UIKit
import Combine

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

@MainActor
final class PokemonViewModel: ObservableObject {
    @Published var imageState: ImageState = .empty
    
    @Published var image: UIImage?
    @Published var name: String = "" // Pikachu
    @Published var height: String = "" // 0.4m
    @Published var weight: String = "" // 6.0kg
    @Published var id: String = "" // #025
    @Published var type: String = "" // electric
    
    enum ImageState {
        case empty
        case loading
        case loaded(UIImage)
        case error
        
        var image: UIImage? {
            if case .loaded(let image) = self {
                return image
            }
            return nil
        }
    }
    
    private let useCase: PokemonUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(useCase: PokemonUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func searchPokemon(withName name: String) {
        imageState = .empty
        
        useCase.getPokemon(withName: name)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    self?.imageState = .error
                }
                
            } receiveValue: { [weak self] pokemon in
                self?.updatePokemonInfo(with: pokemon)
                self?.loadPokemonImage(from: pokemon.imageURL)
                
            }
            .store(in: &cancellables)
    }
    
    private func loadPokemonImage(from url: URL?) {
        guard let imageURL = url else {
            imageState = .error
            return
        }
        
        imageState = .loading
        
        useCase.getImage(fromURL: imageURL)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.imageState = .error
                }
            } receiveValue: { [weak self] data in
                if let image = UIImage(data: data) {
                    self?.imageState = .loaded(image)
                } else {
                    self?.imageState = .error
                }
            }
            .store(in: &cancellables)
    }
    
    private func updatePokemonInfo(with pokemon: PokemonDomainModel) {
        name = pokemon.displayName
        height = pokemon.meterHeight
        weight = pokemon.kgWeight
        id = pokemon.formattedID
        type = pokemon.type
    }
}
