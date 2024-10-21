//
//  PokemonInfoCard.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct PokemonInfoCard: View {
    struct InfoData {
        let name: String
        let height: String
        let weight: String
        let id: String
    }
    
    let info: InfoData
    
    var body: some View {
        VStack(alignment: .leading) {
            InfoRow(label: "Name", value: info.name)
            InfoRow(label: "Height", value: info.height)
            InfoRow(label: "Weight", value: info.weight)
            InfoRow(label: "ID", value: info.id)
            Spacer()
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(CardBackground())
    }
}

#Preview {
    PokemonInfoCard(info:
            .init(name: "Pikachu",
                  height: "0.4m",
                  weight: "6.0kg",
                  id: "#025")
    )
}
