//
//  BUShuttle.swift
//  MapsDirection
//
//  Created by Andreas Papadakis on 4/30/18.
//  Copyright © 2018 balitax. All rights reserved.
//

import Foundation
import UIKit


class BUShuttle: UIViewController{
    
    //first input argument: ETA label
    //second input argument: details label
    //third input argument: origin coordinates as a string
    //fourh input argument: destination coordinates as a string
    //This is true for every function: getTrainData, getBusData, getWalkingData
    
    func getShuttleData(completionHandler: @escaping ([String: Any]) -> ()){
        
        let urlstring = "https://www.bu.edu/bumobile/rpc/bus/livebus.json.php"
        let urlrequest = URLRequest(url: URL(string: urlstring)!)
        let config = URLSessionConfiguration.default
        let sessions = URLSession(configuration: config)
        
        let task = sessions.dataTask(with: urlrequest) { (data, response, error) in
            guard error == nil else {
                print("error getting data")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("error, did not receive data")
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]{
                    completionHandler(json)
                }
                
            }
            catch {
                print("Error, could not configure data")
            }
            
        }
        task.resume()
    }
}
