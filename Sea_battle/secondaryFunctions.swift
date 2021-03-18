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
