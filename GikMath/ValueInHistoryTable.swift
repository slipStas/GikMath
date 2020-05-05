//
//  ValueInHistoryTable.swift
//  GikMath
//
//  Created by Stanislav Slipchenko on 19.01.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

class MathSec {
    let id : Int
    let value : String
    let correctly : Bool
    let time : String
    let timeCounter : Double
    let secondCounter : Double
    
    init(id:Int, value:String, correctly:Bool, time:String, timeCounter: Double, secondCounter: Double) {
        self.id = id
        self.value = value
        self.correctly = correctly
        self.time = time
        self.timeCounter = timeCounter
        self.secondCounter = secondCounter
    }
}
