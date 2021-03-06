//
//  computerLogic.swift
//  Sea_battle
//
//  Created by Torpheus on 17.03.2021.
//

import Foundation

var firstPoint = [Int]()
var nextPoint = [Int]()
var avalibleDirection = [[Int]: Direction]()
var attackField = [[Int]: Bool]()
var coordinateWounded = [[Int]: Bool]()
var stateComputer = ComputerMove.shoot
var lenghtShip = 0
var rightDirection = true
var directionForShoot = Direction.east
var wounded = false
var killed = false

// computer State
enum ComputerMove {
    case shoot, findDirection, finish
}

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
        
        // if next cell is avalible on field
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
    var result: [Any]
    
    repeat {
        switch stateComputer {
        case .shoot:
            firstState()
            break
        case .findDirection:
            directionForShoot = secondState()
            break
        default:
            thirdState(direction: directionForShoot)
            break
        }
        
        result = userField.fire(nextPoint[0], nextPoint[1], whoseFire: computerField.identifier)
        wounded = result[0] as! Bool
        killed = result[1] as! Bool
        
        clearTerminal()
        printAllField(userField, computerField)
        
        // checking the result of the shot
        if killed {
            lenghtShip += 1
            stateComputer = .shoot
            avalibleDirection = [:]
            // add last point ship
            coordinateWounded[nextPoint] = false
            // add free zone for shoot
            removeInvalidCell()
            switch lenghtShip {
            case 4:
                print(Message.battleshipDead.description)
            case 3:
                print(Message.cruiserDead.description)
            case 2:
                print(Message.destroyerDead.description)
            default:
                print(Message.boatDead.description)
            }
            lenghtShip = 0
            Thread.sleep(forTimeInterval: 2)
        } else if wounded && !killed && lenghtShip >= 2 {
            print("\n?????? ????????????????????...")
            lenghtShip += 1
            stateComputer = .finish
            coordinateWounded[nextPoint] = false
            attackField[nextPoint] = false
        } else if !wounded && lenghtShip >= 2 {
            print("\n?????? ????????????????????...")
            stateComputer = .finish
            rightDirection = false
            nextPoint = firstPoint
        } else if wounded && !killed && lenghtShip >= 0 {
            print("\n?????? ????????????????????...")
            lenghtShip += 1
            rightDirection = true
            coordinateWounded[nextPoint] = false
            attackField[nextPoint] = false
            if lenghtShip > 1 {
                stateComputer = .finish
            } else {
                allAvalibleDirectionShoot()
                stateComputer = .findDirection
            }
        } else if !wounded && lenghtShip > 0 {
            print("\n?????? ????????????????????...")
            stateComputer = .findDirection
        } else {
            print("\n?????? ????????????????????...")
            stateComputer = .shoot
        }
        Thread.sleep(forTimeInterval: 1)
    } while wounded
}
