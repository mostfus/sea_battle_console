//
//  Ship.swift
//  Sea_battle
//
//  Created by Torpheus on 08.03.2021.
//

import Foundation

enum Cell: Int {
    case one = 1, two, three, four
    
    var size: Int {
        return self.rawValue
    }
}

struct Point {
    var x, y: Int
}

struct Size {
    var height: Int
    var width: Int
}

struct Rect {
    var origin: Point
    var size: Size
}

enum Direction {
    case north
    case south
    case east
    case west
    
}

enum State: String {
    case afloat = "⏺"
    case wounded = "✴️"
    case killed = "🅾️"
}


struct Ship {
    var size: Cell
    var body: Rect
    var direction: Direction
    var deckArray = [[Int]: State]()
    var state: State
    
    init(size: Cell, body: Rect, direction: Direction) {
        self.size = size
        self.body = body
        self.direction = direction
        
        state = State.afloat
    }
}


