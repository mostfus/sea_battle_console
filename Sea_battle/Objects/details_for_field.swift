//
//  Details_for_field.swift
//  Sea_battle
//
//  Created by Torpheus on 16.03.2021.
//

import Foundation

enum Letter: Int {
    case A = 1, B, C, D, E, F, G, H, I, J
    
    static subscript(letter: String) -> Int {
        switch letter {
        case "a":
            return 1
        case "b":
            return 2
        case "c":
            return 3
        case "d":
            return 4
        case "e":
            return 5
        case "f":
            return 6
        case "g":
            return 7
        case "h":
            return 8
        case "i":
            return 9
        default:
            return 10
        }
    }
    
    static subscript(index: Int) -> Letter {
        return Letter(rawValue: index)!
    }
}

enum CellType: String {
    case border = "🔲"
    case sea = "🟦"
    case miss = "⚪️"
    case doNotShoot = "🌀"
    
    static subscript(cellType: CellType) -> String {
        switch cellType {
        case .border:
            return CellType.border.rawValue
        case .sea:
            return CellType.sea.rawValue
        case .miss:
            return CellType.miss.rawValue
        case .doNotShoot:
            return CellType.doNotShoot.rawValue
        }
    }
}

enum Identifier {
    case user, computer, test
}
