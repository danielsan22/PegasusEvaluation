//
//  ConversionLog.swift
//  PegasusEvaluation
//
//  Created by Daniel Sanchez on 16/09/18.
//  Copyright © 2018 DanielSR. All rights reserved.
//

import UIKit

class ConversionLog: NSObject {
    var id: Int?
    var celsius: String?
    var fahrenheit: String?
    var dateTime: Int?
    
    init(id: Int, celsius: String, fahrenheit: String, dateTime: Int) {
        self.id = id
        self.celsius = celsius
        self.fahrenheit = fahrenheit
        self.dateTime = dateTime
    }
    override var description: String {
        return "id=\(id!), celsius=\(celsius!), fahrenheit=\(fahrenheit!), dateTime=\(dateTime!)"
    }
    
}
