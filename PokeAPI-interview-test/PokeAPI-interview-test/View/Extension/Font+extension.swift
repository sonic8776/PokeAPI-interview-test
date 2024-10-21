//
//  Font+extension.swift
//  PokeAPI-interview-test
//
//  Created by Judy Tsai on 2024/10/21.
//

import SwiftUI

extension Font {
    static func manrope(_ size: CGFloat, weight: Weight = .regular) -> Font {
        return .custom("Manrope-\(weight)", size: size)
    }
    
    // Convenience methods for common text styles
    static let manropeHeadline = manrope(18, weight: .bold)
    static let manropeBody = manrope(16, weight: .bold)
}
