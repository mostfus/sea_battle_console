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

// func for computer fire
func computerFire(_ computerField: inout Battleground, _ userField: inout Battleground) {
    var computerFire: Bool
    repeat {
        print(computerField.shootsData.count)
        let shot = computerField.shootsData.randomElement()!
        print(computerField.shootsData.count)
        let h = letters[shot.key[0] - 1]
        let w = String(shot.key[1])
        computerFire = userField.fire(w, h)
    } while computerFire
}

// function that controls the logic of the game
func game() {
    print("\nПожалуйста введите свой ник:")
    var userName = ""
    if let answer = readLine() {
        userName = answer
    }
    // попросить ввести ник для игры
    var userField = Battleground(identifier: userName)
    var computerField = Battleground(identifier: "Computer")
    var userCommand = [String]()
    let ask = true
    var game = true
    
    gameLoop: while game {
        userField.printBattleground(true, whoseMove: userField.identifier)
        print("")
        computerField.printBattleground(false, whoseMove: computerField.identifier)
        
        askLoop: repeat {
            print("\nВведите команду:") // use message
            
            if let answer = readLine() {
                userCommand = answer.lowercased().split(separator: " ").map(String.init)
            }
            
            if userCommand.count == 2 && letters.contains(userCommand[0]) && nums.contains(userCommand[1])  {
                if computerField.fire(userCommand[1], userCommand[0]) {
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

