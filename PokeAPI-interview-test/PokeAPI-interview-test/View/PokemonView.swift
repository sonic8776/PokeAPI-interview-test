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
            switch viewModel.imageState {
            case .empty:
                Color.clear
                    .frame(width: 200, height: 200)
                
            case .loading:
                ProgressView()
                    .frame(width: 200, height: 200)
                
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .scaledToFit()
                    .overlay(
                        // rounded border
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.pokemonLightGray, lineWidth: 4)
                    )
                
            case .error:
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .frame(width: 50, height: 50)
                    .frame(width: 200, height: 200)
            }
            
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Name: \(viewModel.name)")
                    Text("Height: \(viewModel.height)")
                    Text("Weight: \(viewModel.weight)")
                    Text("ID: \(viewModel.id)")
                    Spacer()
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.pokemonLightGray, in: .rect(cornerRadius: 8))
                
                
                VStack(alignment: .leading) {
                    Text("type")
                    Text(viewModel.type)
                        .frame(width: 153, height: 26)
                        .background(Color.pokemonLightGray)
                        .clipShape(
                            Capsule(style: .continuous)
                        )
                    Spacer()
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
