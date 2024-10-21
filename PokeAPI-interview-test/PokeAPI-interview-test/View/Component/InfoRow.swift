//
//  InfoRow.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        Text("\(label): \(value)")
    }
}

#Preview {
    InfoRow(label: "Name", value: "Pikachu")
}
