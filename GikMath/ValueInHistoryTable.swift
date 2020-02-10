//
//  ValueInHistoryTable.swift
//  GikMath
//
//  Created by Stanislav Slipchenko on 19.01.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

enum Color {
    case red
    case green
}
class Math {
    let value : String
    let color : Color
    let time : String
    let timeCounter : Double
    let secondCounter : Double?
    
    init(value:String, color:Color, time:String, timeCounter: Double, secondCounter: Double?) {
        self.value = value
        self.color = color
        self.time = time
        self.timeCounter = timeCounter
        self.secondCounter = secondCounter
    }
}
