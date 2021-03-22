//
//  Ship.swift
//  Sea_battle
//
//  Created by Torpheus on 08.03.2021.
//

import Foundation

enum Life: Int {
    case one = 1, two, three, four
    
    var size: Int {
        return self.rawValue
    }
}

enum Direction: Int {
    case north = 1, south, east, west
    
    static subscript(index: Int) -> Direction {
        return Direction(rawValue: index)!
    }
    
    static subscript(move: Direction) -> Int {
        var value = 0
        switch move {
        case .north:
            value = -1
        case .south:
            value = 1
        case .east:
            value = 1
        case .west:
            value = -1
        }
        return value
    }
}

enum State: String {
    case afloat = "❎"
    case wounded = "🟠"
    case killed = "❌"
}

struct Point {
    var h, w: Int
}

struct Size {
    var height: Int
    var width: Int
}

struct Ship {
    // MARK: - Properties
    
    var size: Int
    var life: Int
    var direction: Direction
    var origin: Point
    var shipCoordinate = [[Int]: String]()
    var state: State {
        if life < 1 {
            return .killed
        } else {
            return .afloat
        }
    }
    
    init(size: Int, direction: Direction, origin: Point) {
        self.size = size
        self.life = size
        self.direction = direction
        self.origin = origin
        
        createShip()
    }
    
    // MARK: - Methods
    
    mutating func createShip() {
        var count = size
        var point = origin
        shipCoordinate[[origin.h, origin.w]] = State.afloat.rawValue
        
        if count > 1 {
            if direction == .north || direction == .south {
                while count > 1 {
                    point.h += Direction[direction]
                    shipCoordinate[[point.h, origin.w]] = State.afloat.rawValue
                    count -= 1
                }
            } else {
                while count > 1 {
                    point.w += Direction[direction]
                    shipCoordinate[[origin.h, point.w]] = State.afloat.rawValue
                    count -= 1
                }
                
            }
        }
    }
    
    mutating func woundedDeck(_ h: Int,_ w: Int) {
        shipCoordinate[[h, w]] = State.wounded.rawValue
        life -= 1
        if life < 1 {
            for (key, _) in shipCoordinate {
                shipCoordinate[key] = State.killed.rawValue
            }
        }
    }
    
    // subscript for access coordinate
    subscript(_ h: Int, w: Int) -> String? {
        return shipCoordinate[[h, w]]
    }
}
