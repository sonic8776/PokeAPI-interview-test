//
//  PokemonDomainModel.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import Foundation

struct PokemonDomainModel {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let type: String
    let imageURL: URL?
    
    init(fromDTO dto: PokemonDTO) {
        self.id = dto.id
        self.name = dto.name
        self.height = dto.height
        self.weight = dto.weight
        self.type = dto.types.first?.type.name ?? "N/A"
        self.imageURL = URL(string: dto.sprites.other.home.frontDefault)
    }
    
    /// "#025"
    var formattedID: String {
        String(format: "#%03d", id)
    }
    
    /// "Pikachu"
    var displayName: String {
        name.capitalized
    }
    
    /// "0.4m"
    var meterHeight: String {
        formatToDecimalPlace(value: Double(height) / Double(10)) + "m"
    }
    
    /// "6.0kg"
    var kgWeight: String {
        formatToDecimalPlace(value: Double(weight) / Double(10)) + "kg"
    }
}

private extension PokemonDomainModel {
    func formatToDecimalPlace(value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = .halfUp
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
