//
//  TypeBadge.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct TypeBadge: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.manropeBody)
            .frame(width: 153, height: 26)
            .background(Color.pokemonLightGray)
            .clipShape(Capsule(style: .continuous))
    }
}

#Preview {
    TypeBadge(text: "electric")
}
