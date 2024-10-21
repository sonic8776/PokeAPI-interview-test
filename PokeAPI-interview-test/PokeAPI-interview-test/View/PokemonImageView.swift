//
//  PokemonImageView.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct PokemonImageView: View {
    let imageState: PokemonViewModel.ImageState
    
    var body: some View {
        Group {
            switch imageState {
            case .empty:
                PlaceholderView()
                
            case .loading:
                LoadingView()
                
            case .loaded(let image):
                LoadedImageView(image: image)
                
            case .error:
                ErrorView()
            }
        }
    }
}

// MARK: - Image State Views

private struct PlaceholderView: View {
    var body: some View {
        Color.clear
    }
}

private struct LoadingView: View {
    var body: some View {
        ProgressView()
    }
}

private struct LoadedImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .scaledToFit()
            .modifier(PokemonImageBorder())
    }
}

private struct ErrorView: View {
    var body: some View {
        Image(systemName: "exclamationmark.triangle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.red)
            .frame(width: 50, height: 50)
    }
}

#Preview {
    PokemonImageView(
        // mock pokemon image
        imageState: .loaded(UIImage(systemName: "star.fill")!)
    )
}
