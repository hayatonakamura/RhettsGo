//
//  Transports.swift
//  MapsDirection
//
//  Created by Hayato Nakamura on 2018/04/24.
//  Copyright © 2018 balitax. All rights reserved.
//

import Foundation
import UIKit

class Transports: UIViewController{
    
    //first input argument: ETA label
    //second input argument: details label
    //third input argument: origin coordinates as a string
    //fourh input argument: destination coordinates as a string
    //This is true for every function: getTrainData, getBusData, getWalkingData
    
    func getTrainData(origin: String, destination: String, completionHandler: @escaping ([String: Any]) -> ()){
        
        let jsonURLString = "https://maps.googleapis.com/maps/api/directions/json?"
        let key = "AIzaSyAYQYjp_C4gySyTcGvSlV2VgQu8gz6KTzE"
        
        
        let urlstring = jsonURLString + "origin=" + origin + "&destination=" + destination + "&key=" + key + "&mode=transit&transit_mode=rail"
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
    
    
    
    func getBusData(origin: String, destination: String, completionHandler: @escaping ([String: Any]) -> ()){
        let jsonURLString = "https://maps.googleapis.com/maps/api/directions/json?"
        let key = "AIzaSyAYQYjp_C4gySyTcGvSlV2VgQu8gz6KTzE"
        let urlstring = jsonURLString + "origin=" + origin + "&destination=" + destination + "&key=" + key + "&mode=transit&transit_mode=bus"
        
        
        let urlrequest = URLRequest(url: URL(string: urlstring)!)
        
        
        let config = URLSessionConfiguration.default
        let sessions = URLSession(configuration: config)
        
        var results: [String] = []
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
                    // print(json)
                    
                    completionHandler(json)
                }
                
            }
            catch {
                print("Error, could not configure data")
            }
            
        }
        task.resume()
    }
    
    func getWalkingData(origin: String, destination: String, completionHandler: @escaping ([String: Any]) -> ()){
        
        var results: [String] = []
        let jsonURLString = "https://maps.googleapis.com/maps/api/directions/json?"
        let key = "AIzaSyAYQYjp_C4gySyTcGvSlV2VgQu8gz6KTzE"
        let urlstring = jsonURLString + "origin=" + origin + "&destination=" + destination + "&key=" + key + "&mode=walking"
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
            catch{
                print("could not configure data")
            }
        }
        task.resume()
        
    }
    
    
    //returns a string which is the URL to create a deeplink for Google Maps
    //choice == bus , return BUS url
    //choice == train , return Train Url
    
    
    func getgoogleURL(choice: String, origin: String, destination: String) -> String{
        let str = "comgooglemaps://?" + "saddr=" + origin + "&daddr=" + destination + "&directionsmode=" //transit
        let res: String
        if (choice == "bus" || choice == "train"){
            res = str + "transit" + "&transitmode=bus"
        }
        else {
            res = str + "walking"
        }
        return res
        
    }
    
    
    
    
    
    
    
}
