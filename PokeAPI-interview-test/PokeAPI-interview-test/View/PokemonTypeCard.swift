//
//  PokemonTypeCard.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct PokemonTypeCard: View {
    let type: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("type")
            TypeBadge(text: type)
            Spacer()
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PokemonTypeCard(type: "electric")
}
