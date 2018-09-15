//
//  ViewController.swift
//  PegasusEvaluation
//
//  Created by Daniel Sanchez on 13/09/18.
//  Copyright © 2018 DanielSR. All rights reserved.
//

import UIKit
import Alamofire
import AEXML

class ViewController: UIViewController, ConverterVCDelegate{
  
    
    
    @IBOutlet weak var tfCelsius: UITextField!
    @IBOutlet weak var lblFarenheit: UILabel!
    
    var viewModel : ConverterViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ConverterViewModel()
        viewModel?.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func conertButtonPressed(_ sender: UIButton) {
        if self.tfCelsius.text != nil && self.tfCelsius.text!.count > 0{
            viewModel?.convert(celsius: tfCelsius.text!)
        } else {
            //TODO: Show an alert
        }
    }
    func showAlert(message:String, isError:Bool) {
        let title = isError ? "Error" : "Info"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: ConverterVCDelegate
    func convertionFinished(farenheit: String) {
        self.lblFarenheit.text = farenheit
    }
    
    func convertionEndedWithError(message: String) {
        showAlert(message: message, isError: true)
        print(message)
    }
}

//
//func getJson() {
//
//    guard let url = URL(string: "http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso?WSDL")
//        else {
//            return
//    }
//    let headers: HTTPHeaders = [
//        "Content-Type": "text/xml"
//    ]
//
//    Alamofire.request(url,
//                      method: .post,
//                      parameters: ["include_docs": "true"])
//        .validate()
//        .responseData(completionHandler: { (response) in
//            print(response)
//        })
//    //            .responseJSON { response in
//    //                guard response.result.isSuccess else {
//    //                    print("Error")
//    //                    return
//    //                }
//    //                guard let value = response.result.value as? [String: Any],
//    //                    let rows = value["rows"] as? [[String: Any]] else {
//    //                        print("Malformed data received from fetchAllRooms service")
//    //                        return
//    //                }
//    //
//    //        }
//
//
//}
//
//func getJson2() {
//
//    //let soapRequest = AEXMLDocument()
//    if let url = URL(string: "http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso?WSDL") {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = HTTPMethod.get.rawValue
//
//        var headers: HTTPHeaders
//        if let existingHeaders = urlRequest.allHTTPHeaderFields {
//            headers = existingHeaders
//        } else {
//            headers = HTTPHeaders()
//        }
//        headers["Content-Type"] = "text/xml"
//        urlRequest.allHTTPHeaderFields = headers
//
//        Alamofire.request(urlRequest)
//            .responseData(completionHandler: { (response) in
//                debugPrint(response)
//            })
//
//        debugPrint(request)
//    }
//}

