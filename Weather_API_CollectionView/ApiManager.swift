//
//  ApiManager.swift
//  Michael_Jackson_API
//
//  Created by pankaj vats on 04/07/18.
//  Copyright © 2018 pankaj vats. All rights reserved.
//


import Foundation
import Alamofire

protocol apiManagerDelegate:NSObjectProtocol {
    func APIFailureResponse(_ msgError: String)
    func apiSuccessResponse(_ response : NSDictionary)
    func apiSuccessResponseArray(_ response : NSArray)
    
    //    add on another api
    
}

extension apiManagerDelegate {
    func APIFailureResponse(_ msgError: String){
        // leaving this empty
    }
    func apiSuccessResponseArray(_ response: NSArray) {
        print ("hello apimanager Array Response\(response)")
        
    }
    func apiSuccessResponse(_ response : NSDictionary){
        print ("hello apimanager \(response)")
    }
}
class ApiManager: NSObject,apiManagerDelegate {
    
    fileprivate let API_STATUS = "error_status"
    var delegate :apiManagerDelegate?
    var appConstants: AppConstants = AppConstants()
    
//     Weather API Call

    func Weather_ApiCall()
    {

        let postString = appConstants.MainHost
        print(" MainHost:\(postString)")

        Alamofire.request(postString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
            {

                response in
                do {
                    if let mdata = response.data
                    {
                        if mdata.isEmpty
                        {
                            print("no data available")
                            return
                        }
                    }
                    // Parsing Data
                    let responseArray =  try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions()) as!  NSDictionary

                    //                    print(responseArray)
                    if  responseArray.count > 0
                    {
                        self.delegate?.apiSuccessResponse(responseArray)
                    }
                    else
                    {
                        self.delegate?.APIFailureResponse("Error...")
                    }
                }
                catch
                {
                    print("error")
                }
        }
    }
}
