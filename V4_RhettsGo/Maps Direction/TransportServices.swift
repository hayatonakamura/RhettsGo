//
//  Services.swift
//  JSONexmaple
//
//  Created by Andreas Papadakis on 4/26/18.
//  Copyright © 2018 Andreas Papadakis. All rights reserved.
//

import Foundation
import UIKit

class TransportServices: UIViewController{
    
func getUberData(origin: String, destination: String, completionHandler: @escaping ([String: Any]) -> ()){
  
   // print("Getting UBER Data")
    let jsonURLString = "https://api.uber.com/v1/estimates/price?&"
    //        "https://api.uber.com/v1/estimates/time?&"
    let startlat = String(origin.prefix(7))
    let startlonnot = String(origin.suffix(10))
    let endlat = String(destination.prefix(7))
   
    let endlonnot = String(destination.suffix(10))
    let startlon = String(startlonnot.prefix(8))
    let endlon = String(endlonnot.prefix(8))
    let key = "q51LEFnq5X1cFZBvsKrJx0iOkUvcihRbgoOG2pv_"
    
    
    
    let urlstring = jsonURLString + "start_latitude=" + startlat + "&start_longitude=" + startlon + "&end_latitude=" + endlat + "&end_longitude=" + endlon + "&server_token=" + key
    print(urlstring)
    
    
    let urlrequest = URLRequest(url: URL(string: urlstring)!)
    
    
    let config = URLSessionConfiguration.default
    let sessions = URLSession(configuration: config)
    
   // var results: [String] = []
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
                //                    print(json)
                
                completionHandler(json)
                
            }
            
            
        }
        catch {
            print("Error with URL Request")
        }
        
        
    }
    task.resume()
    
}
    
    func getLyftData(origin: String, destination: String, completionHandler: @escaping ([String: Any]) -> ()){
        print("GETTING LYFT DATA")
        let jsonURLString = "https://api.lyft.com/v1/cost?"
        //        "https://api.uber.com/v1/estimates/time?&"
        let startlat = String(origin.prefix(7))
        let startlonnot = String(origin.suffix(10))
        let endlat = String(destination.prefix(7))
        
        let endlonnot = String(destination.suffix(10))
        let startlon = String(startlonnot.prefix(8))
        let endlon = String(endlonnot.prefix(8))

        
        
        
        let urlstring = jsonURLString + "start_lat=" + startlat + "&start_lng=" + startlon + "&end_lat=" + endlat + "&end_lng=" + endlon
        print(urlstring)
        
        
        let urlrequest = URLRequest(url: URL(string: urlstring)!)
        
        
        let config = URLSessionConfiguration.default
        let sessions = URLSession(configuration: config)
        
        // var results: [String] = []
        let task = sessions.dataTask(with: urlrequest) {(data, response, error) in
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
                print("Error with URL Request")
            }
            
            
        }
        task.resume()
        }
    
}
