//
//  computerLogic.swift
//  Sea_battle
//
//  Created by Torpheus on 17.03.2021.
//

import Foundation

enum ComputerMove {
    case shoot, shootDirection, finish
}

var firstPoint = [Int]()
var nextPoint = [Int]()
var avalibleDirection = [[Int]: Direction]()
var attackField = [[Int]: Bool]()
var coordinateWounded = [[Int]: Bool]()
var stateComputer = ComputerMove.shoot
var lenghtShip = 0
var rightDirection = true
var directionForShoot = Direction.east

// create matrix for computer attack
func createMatrixField() {
    for h in 1...10 {
        for w in 1...10 {
            attackField[[h, w]] = true
        }
    }
}

func firstState() {
    chooseCell: for (key, value) in attackField {
        if value {
            firstPoint = key
            nextPoint = firstPoint
            attackField[key] = false
            break chooseCell
        }
    }
}

func secondState() -> Direction {
    // get next coordinate for shoot
    let point = avalibleDirection.randomElement()!
    // remove coordonate
    avalibleDirection.removeValue(forKey: point.key)
    nextPoint = point.key
    return point.value
}

func thirdState(direction: Direction) {
    let getNextPoint = true
    
    find: repeat {
        if rightDirection {
            if direction == .north || direction == .south {
                nextPoint[0] += Direction[direction]
            } else {
                nextPoint[1] += Direction[direction]
            }
        } else {
            if direction == .north || direction == .south {
                nextPoint[0] -= Direction[direction]
            } else {
                nextPoint[1] -= Direction[direction]
            }
        }
        
        // next cell is avalible on field
        if attackField.keys.contains(nextPoint) && attackField[nextPoint] != false {
            break find
        }
        nextPoint = firstPoint
        rightDirection = false
    } while getNextPoint
}

func allAvalibleDirectionShoot() {
    let h = firstPoint[0]
    let w = firstPoint[1]
    var point = [h, w + Direction[.east]]
    if  attackField.keys.contains(point) && attackField[point] != false  { avalibleDirection[point] = Direction.east }
    point = [h + Direction[.north], w]
    if  attackField.keys.contains(point) && attackField[point] != false { avalibleDirection[point] = Direction.north }
    point = [h, w + Direction[.west]]
    if attackField.keys.contains(point) && attackField[point] != false { avalibleDirection[point] = Direction.west }
    point = [h + Direction[.south], w]
    if attackField.keys.contains(point) && attackField[point] != false { avalibleDirection[point] = Direction.south }
}

func removeInvalidCell() {
    for (key, value) in coordinateWounded {
        let h = key[0]
        let w = key[1]
        attackField[key] = false
        if let _ = attackField[[h, w + Direction[.east]]] { attackField[[h, w + Direction[.east]]] = value }
        if let _ = attackField[[h + Direction[.north], w + Direction[.east]]] { attackField[[h + Direction[.north], w + Direction[.east]]] = value }
        if let _ = attackField[[h + Direction[.north], w]] { attackField[[h + Direction[.north], w]] = value }
        if let _ = attackField[[h + Direction[.north], w + Direction[.west]]] { attackField[[h + Direction[.north], w + Direction[.west]]] = value }
        if let _ = attackField[[h, w + Direction[.west]]] { attackField[[h, w + Direction[.west]]] = value }
        if let _ = attackField[[h + Direction[.south], w + Direction[.west]]] { attackField[[h + Direction[.south], w + Direction[.west]]] = value }
        if let _ = attackField[[h + Direction[.south], w]] { attackField[[h + Direction[.south], w]] = value }
        if let _ = attackField[[h + Direction[.south], w + Direction[.east]]] { attackField[[h + Direction[.south], w + Direction[.east]]] = value }
    }
    coordinateWounded = [:]
}

func computerFire(_ computerField: inout Battleground, _ userField: inout Battleground) {
    var result: (wounded: Bool,killed: Bool)
    
    repeat {
        switch stateComputer {
        case .shoot:
            firstState()
            break
        case .shootDirection:
            directionForShoot = secondState()
            break
        default:
            thirdState(direction: directionForShoot)
            break
        }
        
        result = userField.fire(nextPoint[0], nextPoint[1], whoseFire: computerField.identifier)
        print("computerFire: \(nextPoint)")
        
        if result.killed {
            lenghtShip = 0
            stateComputer = .shoot
            avalibleDirection = [:]
            // add last point ship
            coordinateWounded[nextPoint] = false
            // add free zone for shoot
            removeInvalidCell()
        } else if result.wounded && !result.killed && lenghtShip >= 2 {
            lenghtShip += 1
            stateComputer = .finish
            coordinateWounded[nextPoint] = false
            attackField[nextPoint] = false
        } else if !result.wounded && lenghtShip >= 2 {
            stateComputer = .finish
            rightDirection = false
            nextPoint = firstPoint
        } else if result.wounded && !result.killed && lenghtShip >= 0 {
            lenghtShip += 1
            rightDirection = true
            coordinateWounded[nextPoint] = false
            attackField[nextPoint] = false
            if lenghtShip > 1 {
                stateComputer = .finish
            } else {
                allAvalibleDirectionShoot()
                stateComputer = .shootDirection
            }
        } else if !result.wounded && lenghtShip > 0 {
            stateComputer = .shootDirection
        } else {
            stateComputer = .shoot
        }
    } while result.wounded
}
