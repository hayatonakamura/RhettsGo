//
//  SecondViewController.swift
//  MapsDirection
//
//  Created by Hayato Nakamura on 2018/04/11.
//  Copyright © 2018 balitax. All rights reserved.
//

import Foundation
import UIKit
import LyftSDK
//import SwiftyJSON
import Alamofire
import UberRides
import CoreLocation

class SecondViewController: UIViewController {
    
    @IBOutlet weak var buslabel: UILabel!
    @IBOutlet weak var trainlabel: UILabel!
    @IBOutlet weak var walklabel: UILabel!
    //@IBOutlet weak var lyftbutton_b: LyftButton!
    @IBOutlet weak var walkinglabeleta: UILabel!
    @IBOutlet weak var lyftlabel: UILabel!
    @IBOutlet weak var lyftlabeleta: UILabel!
    @IBOutlet weak var uberlabel: UILabel!
    @IBOutlet weak var Shuttlelabel: UILabel!
    @IBOutlet weak var Shuttlelabeleta: UILabel!
    
    @IBOutlet weak var uberlabeleta: UILabel!
    @IBOutlet weak var trainlabeleta: UILabel!
    @IBOutlet weak var buslabeleta: UILabel!
    var originstring:String!
    var destinationstring:String!
    
    var newlat1:Double!
    var newlon1:Double!
    var newlat2:Double!
    var newlon2:Double!
    
    var busString1 = String()
    var busString2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If we want to display text
        //buslabel.text = busString1
        
        
        let builder = RideParametersBuilder()
        //let pickupLocation = CLLocation(latitude: 42.352069, longitude: -71.115538)
        //let dropoffLocation = CLLocation(latitude: 42.349363, longitude: -71.106725)
        let pickupLocation = CLLocation(latitude: newlat1, longitude: newlon1)
        let dropoffLocation = CLLocation(latitude: newlat2, longitude: newlon2)
        builder.pickupLocation = pickupLocation
        builder.dropoffLocation = dropoffLocation
        //builder.dropoffNickname = "Photonics"
        //builder.dropoffAddress = "8 St. Marys st"
        //let rideParameters = builder.build()
        //let deeplink = RequestDeeplink(rideParameters: rideParameters, fallbackType: .mobileWeb)
        //let button = RideRequestButton(rideParameters: rideParameters)
        
        //button.frame.origin = CGPoint(x: 25, y: 130)
        // changing button size
        //button.frame.size = CGSize(width: 280.0, height: 50.0)
        //view.addSubview(button)
        
        let pickup = CLLocationCoordinate2D(latitude: newlat1, longitude: newlon1)
        let destination = CLLocationCoordinate2D(latitude: newlat2, longitude: newlon2)
        //lyftbutton_b.configure(rideKind: LyftSDK.RideKind.Standard, pickup: pickup, destination: destination)
        
        
        print("Andreas")
        print("Origin:")
        //print(originstring)
        print("Destination:")
        //print(destinationstring)
        print("done")


        let shuttle = BUShuttle()
        shuttle.getShuttleData(){ json in
            let startlat = String(self.originstring.prefix(7))
            let startlonnot = String(self.destinationstring.suffix(10))
            let endlat = String(self.destinationstring.prefix(7))
            
            let endlonnot = String(self.destinationstring.suffix(10))
            let startlon = String(startlonnot.prefix(8))
            let endlon = String(endlonnot.prefix(8))
        }
        let cs = Transports()
        let tr = TransportServices()
        tr.getUberData(origin: originstring, destination: destinationstring){ json in
            if let diff = json["prices"] as? [[String:Any]]{
                for uber in diff{
                    //                            print("sup")
                    //                            print(uber)
                    let name = uber["display_name"] as! String
                    //                            print(name)
                    if name == "uberX"{
                        let estimate = uber["estimate"] as! String
                        var duration = uber["duration"] as! Double
                        duration = duration / 60
                        var date = NSDate()
                        var str = String(describing: date)
                        let start = str.index(str.startIndex, offsetBy: 11)
                        let end = str.index(str.endIndex, offsetBy: -9)
                        let range = start..<end
                        
                        let mySubstring = str[range]
                        let myString = String(mySubstring)
                        
                        let subHour = String(myString.prefix(2))
                        //        print(subHour)
                        
                        let subminutes = String(myString.suffix(2))
                        
                        var hour: Int = Int(subHour)!
                        var min: Int = Int(subminutes)!
                        
                        hour = hour - 4
                        if (min + Int(duration) > 60){
                            hour=hour+1
                            min = min+Int(duration) - 60
                        }
                        else{
                            min = min + Int(duration)
                        }
                        var pmoram=""
                        if (hour > 12){
                            hour = hour - 12
                            pmoram = "pm"
                        }
                        else {
                            pmoram="am"
                        }
                        let totaltime: String
                        if (min<10){
                            totaltime = String(hour) + ":0" + String(min) + pmoram
                        }else{
                            totaltime = String(hour) + ":" + String(min) + pmoram
                        }
                        
                        //                                let durationstring = String(duration)
                        // print("cool")
                        //                            print(totaltime)
                        //                            print(estimate)
                        //
                        self.uberlabel.text = estimate
                        self.uberlabeleta.text = totaltime
                        
                        
                    }
                }
            }
            print("COOL")
        }
        
        tr.getLyftData(origin: originstring, destination: destinationstring){ json in
            if let lyfts = json["cost_estimates"] as? [[String: Any]]{
                for lyftspec in lyfts{
                    let name = lyftspec["ride_type"] as! String
                    if (name == "lyft"){
                        let durationflsec = lyftspec["estimated_duration_seconds"] as! Double
                        let duration = durationflsec / 60 as Double
                        let costcent = lyftspec["estimated_cost_cents_max"] as! Float
                        let costdollares = costcent/100 as Float
                        var date = NSDate()
                        var str = String(describing: date)
                        let start = str.index(str.startIndex, offsetBy: 11)
                        let end = str.index(str.endIndex, offsetBy: -9)
                        let range = start..<end
                        
                        let mySubstring = str[range]
                        let myString = String(mySubstring)
                        
                        let subHour = String(myString.prefix(2))
                        //        print(subHour)
                        
                        let subminutes = String(myString.suffix(2))
                        
                        var hour: Int = Int(subHour)!
                        var min: Int = Int(subminutes)!
                        
                        hour = hour - 4
                        if (min + Int(duration) > 60){
                            hour=hour+1
                            min = min+Int(duration) - 60
                        }
                        else{
                            min = min + Int(duration)
                        }
                        var pmoram=""
                        if (hour > 12){
                            hour = hour - 12
                            pmoram = "pm"
                        }
                        else {
                            pmoram="am"
                        }
                        let totaltime: String
                        if (min<10){
                            totaltime = String(hour) + ":0" + String(min) + pmoram
                        }else{
                            totaltime = String(hour) + ":" + String(min) + pmoram
                        }
                        print("Lyft")
                        self.lyftlabeleta.text = totaltime
                        self.lyftlabel.text = "Estimated Cost: " + String(costdollares)
                        
                        
                    }
                }
            }
        }
        
        
        cs.getBusData(origin: originstring, destination: destinationstring){json in
            var results: [String] = []
            if let routes = json["routes"] as? [[String: Any]] {
                //                    print(routes)
                for rout in routes {
                    if let legs = rout["legs"] as? [[String: Any]]{
                        for leg in legs{
                            var ETA = ""
                            if let ETAstruct = leg["arrival_time"] as? [String: Any]{
                                if let ETA = ETAstruct["text"]{
                                    self.buslabeleta.text = ETA as? String //set text for ETA label
                                }
                            }
                            
                            //
                            //                                    if let duration = leg["duration"] as? [String: Any]{
                            //                                        let temp = duration["text"] as? String
                            //                                        results.append(temp!)
                            //                                    }
                            //                                    print("sup")
                            if let steps = leg["steps"] as? [[String: Any]]{
                                //                                        print(steps)
                                for step in steps{
                                    let transmode = step["travel_mode"] as? String
                                    var temp = "" as? String
                                    if  transmode == "TRANSIT"{
                                        let details = step["transit_details"] as? [String: Any]
                                        let bustitle = details!["headsign"] as? String
                                        let linedetails = details!["line"] as? [String: Any]
                                        let busnumber = linedetails!["short_name"] as? String
                                        let instruction = step["html_instructions"] as? String
                                        let temp2 = "Take: #" + busnumber! + " " + bustitle!
                                        results.append(temp2)
                                        let arrivalstopdetails = details!["arrival_stop"] as? [String: Any]
                                        let destinationstop = arrivalstopdetails!["name"] as? String
                                        let departurestopdetails = details!["departure_stop"] as? [String: Any]
                                        let departurestop = departurestopdetails!["name"] as? String
                                        let temp3 = "Pick up at: " + departurestop!
                                        results.append(temp3)
                                        let temp4 = "Get off at: " + destinationstop!
                                        results.append(temp4)
                                        
                                        //                                                temp = temp2 + busnumber! + " " + bustitle!
                                    }
                                    else {
                                        //                                                temp = step["html_instructions"] as? String
                                    }
                                    //                                            results.append(temp!)
                                }
                            }
                        }
                    }
                }
                var texts = ""
                for i in results{
                    texts = texts + i + "\n"
                }
                self.buslabel.text = texts
            }
            
        }
        
        
        cs.getTrainData(origin: originstring, destination: destinationstring){json in
            var results: [String] = []
            if let routes = json["routes"] as? [[String: Any]] {
                ////                    print(routes)
                for rout in routes {
                    if let legs = rout["legs"] as? [[String: Any]]{
                        for leg in legs{
                            var ETA = ""
                            if let ETAstruct = leg["arrival_time"] as? [String: Any]{
                                if let ETA = ETAstruct["text"]{
                                    self.trainlabeleta.text = ETA as? String //set text for ETA label
                                }
                            }
                            if let steps = leg["steps"] as? [[String: Any]]{
                                //                                        print(steps)
                                for step in steps{
                                    
                                    let transmode = step["travel_mode"] as? String
                                    var temp = "" as? String
                                    if  transmode == "TRANSIT"{
                                        
                                        //print(step)
                                        let details = step["transit_details"] as? [String: Any]
                                        let linedetails = details!["line"] as? [String: Any]
                                        let arrivaldetails = details!["arrival_stop"] as? [String: Any]
                                        let arrival_stop = arrivaldetails!["name"] as? String
                                        let trainname = linedetails!["name"] as? String
                                        let head = details!["headsign"] as? String
                                        let temp = "Take: " + trainname! + " towards " + head!
                                        //temp = temp2 + " and get off at " + arrival_stop!
                                        results.append(temp)
                                        results.append(arrival_stop!)
                                        
                                    }
                                    else {
                                        temp = step["html_instructions"] as? String
                                        let index = temp?.index((temp?.startIndex)!, offsetBy: 8)
                                        let mySubstring = temp?.suffix(from: index!) // playground
                                        let myString = String(describing: mySubstring) as String!
                                        //                                                print("Sup")
                                        //                                                print(myString)
                                        var yo: String!
                                        yo = myString
                                        results.append(yo!)
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            var textdetails: String = "Loading"
            // textdetails = results[1] + "\nPick up at: " + results[0] + "\nGet off at: " + results[2]
            print(textdetails)
            self.trainlabel.text = textdetails
            print("bus good")
        }
        
        cs.getWalkingData(origin: originstring, destination: destinationstring){json  in
            var results: [String] = []
            if let routes = json["routes"] as? [[String: Any]] {
                
                for rout in routes {
                    if let legs = rout["legs"] as? [[String: Any]]{
                        for leg in legs{
                            if let timedetails = leg["duration"] as? [String: Any]{
                                let time = timedetails["text"] as! String
                                print("time:")
                                print(time)
                                let subtime = String(describing: time.prefix(2)) as! String
                                print("subtime:")
                                print(subtime)
                                let duration = Int(subtime)
                                print("duration: ")
                                print(duration)
                                var date = NSDate()
                                var str = String(describing
                                    : date)
                                let start = str.index(str.startIndex, offsetBy: 11)
                                let end = str.index(str.endIndex, offsetBy: -9)
                                let range = start..<end
                                
                                let mySubstring = str[range]
                                let myString = String(mySubstring)
                                
                                let subHour = String(myString.prefix(2))
                                print("subhour:")
                                print(subHour)
                                
                                let subminutes = String(myString.suffix(2))
                                
                                var hour: Int = Int(subHour)!
                                var min: Int = Int(subminutes)!
                                
                                hour = hour - 4
                                if (min + duration! > 60){
                                    hour=hour+1
                                    min = min+duration! - 60
                                }
                                else{
                                    min = min + duration!
                                }
                                var pmoram=""
                                if (hour > 12){
                                    hour = hour - 12
                                    pmoram = "pm"
                                }
                                else {
                                    pmoram="am"
                                }
                                
                                let totaltime = String(hour) + ":" + String(min) + pmoram
                                self.walkinglabeleta.text = totaltime //set text for ETA label
                            }
                            if let distancedetails = leg["distance"] as? [String: Any]{
                                let distance = distancedetails["text"] as? String
                                let distancetext = "Walking distance: " + distance!
                                results.append(distancetext)
                            }
                            if let steps = leg["steps"] as? [[String: Any]]{
                                for step in steps{
                                    let temp = step["html_instructions"] as? String
                                    results.append(temp!)
                                }
                            }
                        }
                    }
                }
                
                let texts = results[0] + "\n" + "Total # of streets: " + String(results.count-1)
                self.walklabel.text = texts
            }
        }
        
        
        
        
        
    
        // Do any additional setup after loading the view, typically from a nib.
        //        let origin = "42.3493,-71.1040"
        //        let destination = "42.3483,-71.1381"
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func uberbuttonaction(_ sender: Any) {
        let pickupLocation = CLLocation(latitude: newlat1, longitude: newlon1)
        let dropoffLocation = CLLocation(latitude: newlat2, longitude: newlon2)
        let builder = RideParametersBuilder()
        builder.pickupLocation = pickupLocation
        builder.dropoffLocation = dropoffLocation
        let rideParameters = builder.build()
        let deeplink = RequestDeeplink(rideParameters: rideParameters, fallbackType: .mobileWeb)
        deeplink.execute()
    }
    
    @IBAction func lyftbuttonaction(_ sender: Any) {
        let pickup = CLLocationCoordinate2D(latitude: newlat1, longitude: newlon1)
        let destination = CLLocationCoordinate2D(latitude: newlat2, longitude: newlon2)
        LyftDeepLink.requestRide(kind: .Standard, from: pickup, to: destination)
    }
    
    /*
    @IBAction func BUshuttle_deep(_ sender: Any) {
        let cs = Transports()
        let deeplink_bushuttle = cs.getgoogleURL(choice: "bus", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_bushuttle)!, options: [:])
    }
    
    @IBAction func T_deep(_ sender: Any) {
        let cs = Transports()
        let deeplink_T = cs.getgoogleURL(choice: "train", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_T)!, options: [:])
    }
    
    @IBAction func walking_deep(_ sender: Any) {
        let cs = Transports()
        let deeplink_walking = cs.getgoogleURL(choice: "walking", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_walking)!, options: [:])
    }
 */
 
    // new
    @IBAction func deepwalking(_ sender: Any) {
        let cs = Transports()
        let deeplink_walking = cs.getgoogleURL(choice: "walking", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_walking)!, options: [:])
    }
    @IBAction func deepT(_ sender: Any) {
        let cs = Transports()
        let deeplink_T = cs.getgoogleURL(choice: "train", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_T)!, options: [:])
    }
    @IBAction func deepBUs(_ sender: Any) {
        let cs = Transports()
        let deeplink_bushuttle = cs.getgoogleURL(choice: "bus", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_bushuttle)!, options: [:])
    }
    
    
    
    
}
