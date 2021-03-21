//
//  main.swift
//  Sea_battle
//
//  Created by Torpheus on 08.03.2021.
//

import Foundation

var answer = ""
let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
let nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
var startIndex = 0

// function that controls the logic of the game
func game() -> Bool {
    // prepare data
    var userCommand = [String]()
    var printLegend = true
    let ask = true
    let game = true
    var userField = Battleground(identifier: .user)
    var computerField = Battleground(identifier: .computer)
    computerField.makeShipInvisible()
    
    clearTerminal()
    print(Message.legend.description)
    Thread.sleep(forTimeInterval: 5)
    
    // create matrix for computer attack
    createMatrixField()

    gameLoop: while game {
        clearTerminal()
        
        if printLegend {
            print(Message.legend.description)
            Thread.sleep(forTimeInterval: 5)
            printLegend = false
        }
    
        printAllField(userField, computerField)
        
        askLoop: repeat {
            print(Message.enterCommand.description)
            
            if let answer = readLine() {
                userCommand = answer.lowercased().split(separator: " ").map(String.init)
            }
            
            if userCommand.count == 2 && letters.contains(userCommand[0]) && nums.contains(userCommand[1])  {
                let h = Int(userCommand[1])!
                let w = Letter[userCommand[0]]
                // user fire
                if computerField.fire(h, w, whoseFire: userField.identifier).wounded {
                    continue gameLoop
                } else {
                    // computer is fire
                    computerFire(&computerField, &userField)
                    continue gameLoop
                }
            } else if userCommand.count > 0 {
                switch userCommand[0] {
                case "rules":
                    print(Message.rules.description)
                    print(Message.separator.description)
                    continue askLoop
                case "exit":
                    print(Message.endGame.description)
                    return false
                case "commands":
                    print(Message.commands.description)
                    print(Message.separator.description)
                    continue askLoop
                case "start":
                    print(Message.leaveCurrentGame.description)
                    return true
                default:
                    print(Message.errorCommand.description)
                    continue askLoop
                }
            }
            
            // check win or lose
            if userField.score <= 0 {
                print(Message.lose.description)
                return true
            } else if computerField.score <= 0 {
                print(Message.win.description)
                return true
            }
        } while ask
    }
}

// First launch. Print description for game, rules, comand
clearTerminal()
print(Message.firstLaunch.description)
print(Message.separator.description)
print(Message.setting.description)
print(Message.separator.description)
print(Message.commands.description)
print(Message.separator.description)

// Ask about the beginning of the game
startGame: repeat {
    print(Message.enterCommand.description)
    
    if let text = readLine() {
        answer = text.lowercased()
    }
    
    choice: switch answer {
    case "start":
        let gameResult = game()
        if gameResult {
            continue startGame
        }
        break startGame
    case "commands":
        print(Message.separator.description)
        print(Message.commands.description)
    case "rules":
        print(Message.separator.description)
        print(Message.rules.description)
    case "exit":
        print(Message.separator.description)
        print(Message.endGame.description)
        break startGame
    default:
        print(Message.separator.description)
        print("Адмирал, я не могу выполнить этот приказ! Попробуйте еще раз:")
        break
    }
} while answer != "exit"

//Thread.sleep(forTimeInterval: 0.099)

