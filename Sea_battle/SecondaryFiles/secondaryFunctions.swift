//
//  secondaryFunctions.swift
//  Sea_battle
//
//  Created by Torpheus on 18.03.2021.
//

import Foundation

func clearTerminal() {
    let cls = Process()
    let out = Pipe()
    cls.launchPath = "/usr/bin/clear"
    cls.standardOutput = out
    cls.launch()
    cls.waitUntilExit()
    print (String(data: out.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8) ?? "")
}

func spacePrint(_ text: Any) {
    print("\(text)", terminator: " ")
}


func printComputerField(_ field: Battleground) {
    if startIndex <= field.fullHeight {
        for h in startIndex...field.fullHeight {
            switch h {
            case 10:
                spacePrint(h)
            case let x where x != 0 && x != field.fullHeight:
                spacePrint("")
                spacePrint(h)
            default:
                spacePrint("  ")
            }
            
            printCell: for w in 0...field.fullWidth {
            let cell = field.field[[h, w]]!
            spacePrint(cell)
            }
            startIndex += 1
            return
        }
    }
}

func printAllField(_ userField: Battleground, _ computerField: Battleground) {
    // print id
    spacePrint("\t \(userField.identifier)")
    spacePrint("\t\t")
    spacePrint("\t \(computerField.identifier)")
    print("")
    
    //print firstLine Letters
    for _ in 1...2 {
        spacePrint("      ")
        for i in 1...10 {
            let letter = Letter[i]
            spacePrint(letter)
            //print(" ", terminator: "")
            spacePrint("")
        }
        spacePrint("   ")
    }
    print("")
    
    // print both field parallel
    for h in 0...userField.fullHeight {
        switch h {
        case 10:
            spacePrint(h)
        case let x where x != 0 && x != userField.fullHeight:
            spacePrint("")
            spacePrint(h)
        default:
            spacePrint("  ")
        }
        
        printCell: for w in 0...userField.fullWidth {
            for value in userField.arrayShips {
                if let cell = value[h, w] {
                    spacePrint(cell)
                    continue printCell
                }
            }
            let cell = userField.field[[h, w]]!
            spacePrint(cell)
        }
        spacePrint("\t")
        printComputerField(computerField)
        print("")
    }
    print("")
    startIndex = 0
}
