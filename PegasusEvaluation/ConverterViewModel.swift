//
//  ConverterViewModel.swift
//  PegasusEvaluation
//
//  Created by Daniel Sanchez on 15/09/18.
//  Copyright © 2018 DanielSR. All rights reserved.
//

import UIKit

class ConverterViewModel: NSObject {
    
    var delegate: ConverterVCDelegate?
    var db: SqliteManager
    override init() {
        db = SqliteManager()
    }
    
    func convert(celsius:String) {
        if celsius.isNumber() {
            let converter = TempConvert()
            let result = converter.CelsiusToFahrenheit(Celsius: celsius)
            delegate?.convertionFinished(farenheit: result)
//            if delegate != nil {
//
//            }
            db.insertConversion(celsius: celsius, fahrenheit: result)
            listConversions()
        } else {
            delegate?.convertionEndedWithError(message: "Por favor introduce un número")
        }
    }
    func listConversions() {
        for conversionLog in db.readConversions() {
            print(conversionLog)
        }
    }
}
extension String {
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil && self.rangeOfCharacter(from: CharacterSet.letters) == nil
    }
}

protocol ConverterVCDelegate {
    func convertionFinished(farenheit:String)
    func convertionEndedWithError(message:String)
}
