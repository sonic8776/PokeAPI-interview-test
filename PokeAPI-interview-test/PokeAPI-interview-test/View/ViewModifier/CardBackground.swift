//
//  CardBackground.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.pokemonLightGray, in: .rect(cornerRadius: 8))
    }
}
