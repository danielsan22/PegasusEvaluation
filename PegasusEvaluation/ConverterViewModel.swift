//
//  ConverterViewModel.swift
//  PegasusEvaluation
//
//  Created by Daniel Sanchez on 15/09/18.
//  Copyright © 2018 DanielSR. All rights reserved.
//

import UIKit
import AEXML
import Alamofire

class ConverterViewModel: NSObject {
    
    var delegate: ConverterVCDelegate?
    var db: SqliteManager
    override init() {
        db = SqliteManager()
    }
    
    func convert(celsius:String) {
        if celsius.isNumber() {
            //the lines above use no framework, but a page that generates code for consuming soap services.
            //I'm leaving them just for reference.
            //let converter = TempConvert()
            //let result = converter.CelsiusToFahrenheit(Celsius: celsius)
            convertCelsiusToFahrenheit(celsius: celsius, completion: { (response) in
                print("finished \(response)")
                if self.delegate != nil {
                    self.delegate!.convertionFinished(farenheit: response)
                }
                self.db.insertConversion(celsius: celsius, fahrenheit: response)
                self.listConversions()
            })
        } else {
            if delegate != nil{
                delegate!.convertionEndedWithError(message: "Por favor introduce un número")
            }
        }
    }
    
    func listConversions() {
        for conversionLog in db.readConversions() {
            print(conversionLog)
        }
    }
    
    //This should be in a different file
    func convertCelsiusToFahrenheit(celsius: String, completion: @escaping (_ result: String) -> Void) -> Void {
        let soapRequest = AEXMLDocument()
        let attributes = [
            "xmlns:xsi" : "http://www.w3.org/2001/XMLSchema-instance",
            "xmlns:xsd" : "http://www.w3.org/2001/XMLSchema",
            "xmlns:soap":"http://schemas.xmlsoap.org/soap/envelope/"
        ]
        let envelope = soapRequest.addChild(name: "soap:Envelope", attributes: attributes)
        let body = envelope.addChild(name: "soap:Body")
        let celsiusToF = body.addChild(name: "CelsiusToFahrenheit",attributes:["xmlns":"https://www.w3schools.com/xml/"])
        celsiusToF.addChild(name:"Celsius",value:celsius)
        
        let soapLenth = String(soapRequest.xml.characters.count)
        
        let url = URL(string:"https://www.w3schools.com/xml/tempconvert.asmx?wsdl")
        var xmlRequest = URLRequest(url: url!)
        xmlRequest.httpBody = soapRequest.xml.data(using: String.Encoding.utf8)
        xmlRequest.httpMethod = "POST"
        xmlRequest.addValue("text/xml;charset =utf-8", forHTTPHeaderField: "Content-Type")
        xmlRequest.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        
        Alamofire.request(xmlRequest).responseString { (response) in
            if let xmlString = response.result.value {
                let xml = SWXMLHash.parse(xmlString)
                let body =  xml["soap:Envelope"]["soap:Body"]
                if let resultElement = body["CelsiusToFahrenheitResponse"]["CelsiusToFahrenheitResult"].element {
                    let finalResult = resultElement.text
                    completion(finalResult)
                }
            }else{
                print("error fetching XML")
                
            }
            
            
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
