//
//  PokemonDTO.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/20.
//

import Foundation

struct PokemonDTO: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeElement]
    let sprites: Sprites
    
    // MARK: - Nested Types
    
    struct TypeElement: Codable {
        let type: Type
        
        struct `Type`: Codable {
            let name: String
        }
    }
    
    struct Sprites: Codable {
        let other: Other
        
        struct Other: Codable {
            let home: Home
            
            enum CodingKeys: String, CodingKey {
                case home = "home"
            }
            
            struct Home: Codable {
                let frontDefault: String
                
                enum CodingKeys: String, CodingKey {
                    case frontDefault = "front_default"
                }
            }
        }
    }
}
