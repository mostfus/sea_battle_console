//
//  Battleground.swift
//  Sea_battle
//
//  Created by Torpheus on 13.03.2021.
//

import Foundation

enum Letter: Int {
    case A = 0, B, C, D, E, F, G, H, I, J
    
    var value: Int {
        return self.rawValue
    }
    
    static subscript(index: Int) -> Letter {
        return Letter(rawValue: index)!
    }
}

enum CellType: String {
    case border = "🔲"
    case sea = "🟦"
    case miss = "⚪️"
    case doNotShoot = "🔸"
    
    var value: String {
        return self.rawValue
    }
}

func spacePrint(_ text: Any) {
    print("\(text) ", terminator: "")
}

struct Battleground {
    var height = 10
    var width = 10
    var arrayShips = [Ship]()
    var field = [[Int]: String]()
    var arrayShoots = [[Int]: Bool]()
    
    var fullHeight: Int {
        return height + 1
    }
    var fullWidth: Int {
        return width + 1
    }
    
    init() {
        createBattlegroud()
    }
    
    mutating func createBattlegroud() {
        for h in 0...fullHeight {
            for w in 0...fullWidth {
                switch (h, w) {
                case (0, _):
                    field[[h, w]] = CellType.border.rawValue
                case (1...10, let width) where width == 0 || width == 11:
                    field[[h, w]] = CellType.border.rawValue
                case (11, _):
                    field[[h, w]] = CellType.border.rawValue
                default:
                    field[[h, w]] = CellType.sea.rawValue
                }
            }
        }
    }
    
    func printField() {
        spacePrint("      ")
        //print firstLine Letters
        for i in 0...9 {
            let letter = Letter[i]
            spacePrint(letter)
            print(" ", terminator: "")
            if i == 4 {
                print(" ", terminator: "")
            }
        }
        print("")
        // print field
        for h in 0...fullHeight {
            switch h {
            case 10:
                spacePrint(h)
            case let x where x != 0 && x != fullHeight:
                spacePrint(h)
                spacePrint("")
            default:
                spacePrint("  ")
            }
            
            for w in 0...fullWidth {
                let cell = field[[h, w]]!
                spacePrint(cell)
            }
            print("")
        }
    }
}
