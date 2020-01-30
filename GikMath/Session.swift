//
//  Session.swift
//  GikMath
//
//  Created by Stanislav Slipchenko on 19.01.2020.
//  Copyright © 2020 Stanislav Slipchenko. All rights reserved.
//

import Foundation

class Session {
    
    static let shared = Session()
    private init () {}
    
    var theTask = String()
    var theAnswer = String()
    var countTrueAnswers = Int() 
    var countFalseAnswers = Int()

}
