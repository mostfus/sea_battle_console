//
//  main.swift
//  Sea_battle
//
//  Created by Torpheus on 08.03.2021.
//

import Foundation

// print description for game, rules, comand
print("Здаров! Хочешь сыграть в морской бой?") // use Message file

// read answer user
var answer = ""
let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
let nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

func clearTerminal() {
    let cls = Process()
    let out = Pipe()
    cls.launchPath = "/usr/bin/clear"
    cls.standardOutput = out
    cls.launch()
    cls.waitUntilExit()
    print (String(data: out.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8) ?? "")
}

// function that controls the logic of the game
func game() {
    clearTerminal()
    print("\nПожалуйста введите свой ник:")
    var userName = ""
    if let answer = readLine() {
        userName = answer
    }
    // попросить ввести ник для игры
    var userField = Battleground(identifier: userName)
    var computerField = Battleground(identifier: "Computer")
    // create matrix for computer attack
    createMatrixField()
    var userCommand = [String]()
    let ask = true
    var game = true
    
    gameLoop: while game {
        clearTerminal()
        userField.printBattleground(true, whoseMove: userField.identifier)
        print("")
        computerField.printBattleground(false, whoseMove: computerField.identifier)
        
        askLoop: repeat {
            print("\nВведите команду:") // use message
            
            if let answer = readLine() {
                userCommand = answer.lowercased().split(separator: " ").map(String.init)
            }
            
            if userCommand.count == 2 && letters.contains(userCommand[0]) && nums.contains(userCommand[1])  {
                let h = Int(userCommand[1])!
                let w = Letter[userCommand[0]]
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
                    print("правила")
                    continue askLoop
                case "exit":
                    print("Очень жаль! До свидания!")
                    break gameLoop
                default:
                    print("Вы ввели неправильную команду!")
                    continue askLoop
                }
            }
        } while ask
    }
}

// Ask about the beginning of the game
startGame: repeat {
    if let text = readLine() {
        answer = text.lowercased()
    }
    
    switch answer {
    case "start":
        print("start game!")
        game()// start func game()
        break startGame
    case "exit":
        print("Жаль, надеюсь мы скоро увидимся. Попутного вам ветра, капитан!") // use Message file
        break
    default:
        print("Капитан, я не могу выполнить этот приказ! Попробуйте еще раз:")
        break
    }
} while answer != "exit"

