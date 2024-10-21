//
//  ContentView.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/18.
//

import SwiftUI

struct PokemonView: View {
    @StateObject private var viewModel = PokemonViewModelFactory.make()
    
    var body: some View {
        VStack {
            PokemonImageView(imageState: viewModel.imageState)
            
            HStack(alignment: .top, spacing: 12) {
                PokemonInfoCard(
                    info: .init(
                        name: viewModel.name,
                        height: viewModel.height,
                        weight: viewModel.weight,
                        id: viewModel.id
                    )
                )
                
                PokemonTypeCard(type: viewModel.type)
            }
        }
        .padding()
        .onAppear {
            viewModel.searchPokemon(withName: "pikachu")
        }
    }
}

#Preview {
    PokemonView()
}
