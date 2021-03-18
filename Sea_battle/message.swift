//
//  Message.swift
//  Sea_battle
//
//  Created by Torpheus on 13.03.2021.
//

import Foundation

// contain all message for user

// Добавить предупреждение, если игра отображается неправлильно, нужно настроить отступы между буквами

// если вы стреляете в зону куда не имеет смысла стрелять (отмечена так то) вы теряете ход

enum Message: String {
    case firstLaunch, startGame, endGame, rules, commands, errorCommand, win, lose
    // добавить фразы при выстреле и попадании и тд, мимо
    
    // фраза при которой выходит за диапозон поля ! Туда стрелять не имеет смысла там молоко
    
    // для попаданий убийств и промахов можно добавить несколько вариантов ответов, рандомно
    
    var description: String {
        switch self {
        case .firstLaunch:
            return """
Hello commander! Все гуд?
"""
        default:
            return " "
        }
    }
}
