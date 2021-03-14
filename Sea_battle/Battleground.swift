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

func spacePrint(_ text: Any) {
    print("\(text) ", terminator: "")
}

struct Battleground {
    // MARK: - Properties
    
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
        addShipToBattleground()
    }
    
    // MARK: - Methods
    
    private mutating func createBattlegroud() {
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
    
    private mutating func createShip(size: Int, direction: Direction) {
        var point = (0, 0)
        var originPoint = (0, 0)
        var cell = ""
        var find = true
        
        func checkValidPosition(h: Int, w: Int) -> Bool {
            var height = h
            var width = w
            // check ship around cell
            
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            width += Direction[.east]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            height += Direction[.north]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            width += Direction[.west]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            width += Direction[.west]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            height += Direction[.south]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            height += Direction[.south]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            width += Direction[.east]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            width += Direction[.east]
            guard field[[height, width]] != State.afloat.rawValue else { return true }
            
            return false
        }
        
        while find {
            // choose origin point for ship
            point = (Int.random(in: 1...self.height), (Int.random(in: 1...self.width)))
            originPoint = point
            cell = field[[point.0, point.1]]!
            
            switch cell {
            case "🟦" :
                var count = size
                // check ship around
                if direction == .north || direction == .south {
                    find = checkValidPosition(h: point.0, w: point.1)
                    if count > 1 {
                        loopVertical: while count > 1 {
                            point.0 += Direction[direction]
                            guard field[[point.0, point.1]] != CellType[.border] else {
                                find = true
                                break loopVertical
                            }
                            find = checkValidPosition(h: point.0, w: point.1)
                            guard find == false else { break loopVertical }
                            count -= 1
                        }
                    }
                } else {
                    find = checkValidPosition(h: point.0, w: point.1)
                    if count > 1 {
                        loopHorizontal: while count > 1 {
                            point.1 += Direction[direction]
                            guard field[[point.0, point.1]] != CellType[.border] else {
                                find = true
                                break loopHorizontal
                            }
                            find = checkValidPosition(h: point.0, w: point.1)
                            guard find == false else { break loopHorizontal }
                            count -= 1
                        }
                    }
                }
            default:
                break
            }
        }
        
        // create ship and add on battleground
        
        let ship = Ship(size: size, direction: direction, origin: Point(h: originPoint.0, w: originPoint.1))
        arrayShips.append(ship)
        for (key, value) in ship.shipCoordinate {
            field[key] = value
        }
        addMiss(ship)
    }
    
    private mutating func addShipToBattleground() {
        createShip(size: 4, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 3, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 3, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 2, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 2, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 2, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 1, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 1, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 1, direction: Direction[Int.random(in: 1...4)])
        createShip(size: 1, direction: Direction[Int.random(in: 1...4)])
        
        // remove free zone
        
        for (key, value) in field {
            if value == "⚪️" {
                field[key] = "🟦"
            }
        }
    }
    
    // make a free zone around the ship
    private mutating func addMiss(_ ship: Ship) {
        var point = ship.origin
        var originPoint = point
        var lenght = ship.size
        
        func changeCell(_ point: Point) {
            if field[[point.h, point.w]] == "🟦" {
                field[[point.h, point.w]] = CellType[.miss]
            }
        }
        
        while lenght > 0 {
            //fire around
            point = originPoint
            
            point.w += Direction[.east]
            changeCell(point)
            point.h += Direction[.north]
            changeCell(point)
            point.w += Direction[.west]
            changeCell(point)
            point.w += Direction[.west]
            changeCell(point)
            point.h += Direction[.south]
            changeCell(point)
            point.h += Direction[.south]
            changeCell(point)
            point.w += Direction[.east]
            changeCell(point)
            point.w += Direction[.east]
            changeCell(point)
            
            //move next cell
            if ship.direction == .north || ship.direction == .south {
                originPoint.h += Direction[ship.direction]
            } else {
                originPoint.w += Direction[ship.direction]
            }
            lenght -= 1
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
    
    // subscript for access coordinate
}
