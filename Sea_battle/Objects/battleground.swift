//
//  Battleground.swift
//  Sea_battle
//
//  Created by Torpheus on 13.03.2021.
//

import Foundation

struct Battleground {
    // MARK: - Properties
    
    var height = 10
    var width = 10
    var arrayShips = [Ship]()
    var field = [[Int]: String]()
    var score = 20
    var identifier: Identifier
    var shootsData = [[Int] : Bool]()
    
    var fullHeight: Int {
        return height + 1
    }
    var fullWidth: Int {
        return width + 1
    }
    
    init(identifier: Identifier) {
        self.identifier = identifier
        createBattlegroud()
        addShipToBattleground()
        
        // create shoots for computer
        for h in 1...height {
            for w in 1...width {
                shootsData[[h, w]] = true
            }
        }
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
            case CellType[.sea] :
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
        addFreeZone(ship, CellType.miss.rawValue)
    }
    
    private mutating func addShipToBattleground() {
        var count = 1
        var size = 4
        
        // create all ships
        while size > 0 {
            for _ in 1...count {
                createShip(size: size, direction: Direction[Int.random(in: 1...4)])
            }
            count += 1
            size -= 1
        }
        
        // remove free zone and ships
        for (key, value) in field {
            if value == CellType[.miss] {
                field[key] = CellType[.sea]
            }
        }
    }
    
    // make a free zone around the ship
    private mutating func addFreeZone(_ ship: Ship, _ typeCell: String) {
        var point = ship.origin
        var originPoint = point
        var lenght = ship.size
        
        func changeCell(_ point: Point) {
            if field[[point.h, point.w]] == CellType[.sea] || field[[point.h, point.w]] == CellType[.miss] {
                field[[point.h, point.w]] = typeCell
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
    
    mutating func fire(_ height: Int, _ width: Int, whoseFire: Identifier) -> (wounded: Bool,killed: Bool) {
        let h = height
        let w = width
        
        let cell = field[[h, w]]
        
        // check shipDeck for input coordinate (h, w)
        ship: for index in arrayShips.indices {
            if let shipDeck = arrayShips[index].shipCoordinate[[h, w]] {
                if shipDeck != State.wounded.rawValue && shipDeck != State.killed.rawValue {
                    arrayShips[index].woundedDeck(h, w)
                    field[[h, w]] = State.wounded.rawValue
                    // will launch when ship is dead
                    if arrayShips[index].state == .killed {
                        addFreeZone(arrayShips[index], CellType[.doNotShoot])
                        for (key, value) in arrayShips[index].shipCoordinate {
                            field[key] = value
                        }
                        score -= 1
                        return (true, true)
                    }
                    score -= 1
                    guard whoseFire == .computer else { return (true, false) }
                    print("Есть пробитие!")
                    return (true, false)
                } else {
                    guard whoseFire == .computer else { return (false, false) }
                    print("Ты уже стрелял сюда! Сюда не имеет смысла стрелять.") // add message
                    return (false, false)
                }
            }
        }

        switch cell {
        case CellType[.sea]:
            field[[h, w]] = CellType[.miss]
            return (false, false)
        default:
            guard whoseFire == .computer else { return (false, false) }
            print("Ты уже стрелял сюда! Сюда не имеет смысла стрелять.") // add message
            return (false, false)
            
        }
    }
    
    mutating func makeShipInvisible() {
        for (key, value) in field {
            if value == State.afloat.rawValue {
                field[key] = CellType[.sea]
            }
        }
    }
    
    mutating func printBattleground(_ printShip: Bool, whoseMove: String) {
        print("\n\(whoseMove)")
        spacePrint("      ")
        //print firstLine Letters
        for i in 1...10 {
            let letter = Letter[i]
            spacePrint(letter)
            print(" ", terminator: "")
        }
        print("")
        // print field
        for h in 0...fullHeight {
            switch h {
            case 10:
                spacePrint(h)
            case let x where x != 0 && x != fullHeight:
                spacePrint("")
                spacePrint(h)
            default:
                spacePrint("  ")
            }
            
            printCell: for w in 0...fullWidth {
                if printShip {
                    for value in arrayShips {
                        if let cell = value[h, w] {
                            spacePrint(cell)
                            continue printCell
                        }
                    }
                }
                let cell = field[[h, w]]!
                spacePrint(cell)
            }
            print("")
        }
    }
}
