//
//  PokemonImageBorder.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct PokemonImageBorder: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(.pokemonLightGray, lineWidth: 4)
        )
    }
}
