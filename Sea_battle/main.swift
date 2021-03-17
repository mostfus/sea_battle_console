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

// function that controls the logic of the game
func game() {
    var userField = Battleground()
    var computerField = Battleground()
    var userCommand = [String]()
    let ask = true
    let letters = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]
    let nums = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    var game = true
    
    gameLoop: while game {
        userField.printBattleground(printShip: true)
        print("")
        computerField.printBattleground(printShip: true)
        
        askLoop: repeat {
            print("\nВведите команду:") // use message
            
            if let answer = readLine() {
                userCommand = answer.lowercased().split(separator: " ").map(String.init)
            }
            
            if userCommand.count == 2 && letters.contains(userCommand[0]) && nums.contains(userCommand[1])  {
                guard computerField.fire(userCommand[1], userCommand[0]) else { continue gameLoop }
                // ход компьютера
                continue gameLoop
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

