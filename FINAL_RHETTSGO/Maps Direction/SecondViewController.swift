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

struct ShuttleStop{
    var id: String
    var name: String
    var lat: Double
    var lon: Double
}

class SecondViewController: UIViewController {
    
    // fetches the ETA
    func getETA(duration: Int) -> String{
        var date = NSDate()
        var str = String(describing: date)
        let start = str.index(str.startIndex, offsetBy: 11)
        let end = str.index(str.endIndex, offsetBy: -9)
        let range = start..<end
        
        let mySubstring = str[range]
        let myString = String(mySubstring)
        
        let subHour = String(myString.prefix(2))
        print(str)
        //        print(subHour)
        
        let subminutes = String(myString.suffix(2))
        print(subHour)
        print(subminutes)
        var beginhour = Int(subHour)!
        var hour: Int = Int(subHour)!
        var min: Int = Int(subminutes)!
        
        hour = hour - 4
        var pmoram=""
        
        if (hour<0){
            pmoram = "pm"
            hour = hour + 24
        }
        if (min + Int(duration) >= 60){
            hour=hour+1
            min = min+Int(duration) - 60
        }
        else{
            min = min + Int(duration)
        }
        
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
        return totaltime
        
    }
    
    func getD(num1: [Double], num2: [Double]) -> Double{
        let first = num1[0]-num2[0] as Double
        let second = num1[1]-num2[1] as Double
        return sqrt(first*first+second*second)
    }
    
    @IBOutlet weak var buslabel: UILabel!
    @IBOutlet weak var trainlabel: UILabel!
    @IBOutlet weak var walklabel: UILabel!
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

        Shuttlelabel.text = "Terrier Time"
        
        let builder = RideParametersBuilder()
        let pickupLocation = CLLocation(latitude: newlat1, longitude: newlon1)
        let dropoffLocation = CLLocation(latitude: newlat2, longitude: newlon2)
        builder.pickupLocation = pickupLocation
        builder.dropoffLocation = dropoffLocation
        
        let pickup = CLLocationCoordinate2D(latitude: newlat1, longitude: newlon1)
        let destination = CLLocationCoordinate2D(latitude: newlat2, longitude: newlon2)

        let testing = getETA(duration: 20) as String
        // Debug Purposes
        print("TESTING")
        print(testing)
        
        var StopsGoingRight = [ShuttleStop]()
        var StopsGoingLeft = [ShuttleStop]()
        var stop: ShuttleStop
        stop = ShuttleStop(id: "4160714", name: "Student Village 2", lat: 42.353151, lon: -71.11815)
        StopsGoingRight.append(stop)
        stop = ShuttleStop(id: "4114006", name: "Amory St.", lat: 42.35067231, lon: -71.11343645)
        StopsGoingRight.append(stop)
        stop = ShuttleStop(id: "4149154", name: "St. Mary''s St.", lat: 42.34982489, lon: -71.1064171)
        StopsGoingRight.append(stop)
        stop = ShuttleStop(id: "4068466", name: "Blandford St.", lat: 42.34910929, lon: -71.10044919)
        StopsGoingRight.append(stop)
        stop = ShuttleStop(id: "4068470", name: "Hotel Commonwealth", lat: 42.34872900, lon: -71.09573500)
        StopsGoingRight.append(stop)
        stop = ShuttleStop(id: "4110206", name: "Huntington Ave.", lat: 42.34247221, lon: -71.08466171)
        StopsGoingRight.append(stop)
        stop = ShuttleStop(id: "4068482", name: "710 Albany St.", lat: 42.335283, lon: -71.070879)
        StopsGoingRight.append(stop)
        
        
        stop = ShuttleStop(id: "4068482", name: "710 Albany St.", lat: 42.335283, lon: -71.070879)
        StopsGoingLeft.append(stop)
        stop = ShuttleStop(id: "4160718", name: "Huntington Ave.", lat: 42.34237705, lon: -71.08415343)
        StopsGoingLeft.append(stop)
        
        stop = ShuttleStop(id: "4160722", name: "Danielsen Hall", lat: 42.35066800, lon: -71.09019300)
        StopsGoingLeft.append(stop)
        stop = ShuttleStop(id: "4160726", name: "Myles Standish", lat: 42.34931115, lon: -71.09544284)
        StopsGoingLeft.append(stop)
        stop = ShuttleStop(id: "4160730", name: "Silber Way", lat: 42.34950000, lon: -71.10070000)
        StopsGoingLeft.append(stop)
        stop = ShuttleStop(id: "4160734", name: "Marsh Plaza", lat: 42.3501817, lon: -71.10657938)
        StopsGoingLeft.append(stop)
        stop = ShuttleStop(id: "4160738", name: "College of Fine Arts", lat: 42.350891, lon: -71.113483)
        StopsGoingLeft.append(stop)
        stop = ShuttleStop(id: "4160714", name: "Nickerson Field", lat: 42.353151, lon: -71.11815)
        StopsGoingLeft.append(stop)
        var goingleft = 0
        
        
        if (newlat1 < newlat2){
            goingleft = 1
        }
        var originmindist = 10000000 as Double
        var destinationmindist = 10000000 as Double
        var originstop = "" as String
        var destinationstop = "" as String
        var originid = "" as String
        var destinationid = "" as String
        print("1 for left")
        print(goingleft)
        if (goingleft == 1){
            for i in StopsGoingLeft{
                if (originmindist > self.getD(num1: [i.lon, i.lat], num2: [newlon1, newlat1])){
                    originmindist = self.getD(num1: [i.lon, i.lat], num2: [newlon1, newlat1])
                    originstop = i.name
                    originid = i.id
                }
                
                if (destinationmindist > self.getD(num1: [i.lon, i.lat], num2: [newlon2, newlat2])){
                    destinationmindist = self.getD(num1: [i.lon, i.lat], num2: [newlon2, newlat2])
                    destinationstop = i.name
                    destinationid = i.id
                }
                
            }
        }
        else {
            for i in StopsGoingRight{
                if (originmindist > self.getD(num1: [i.lon, i.lat], num2: [newlon1, newlat1])){
                    originmindist = self.getD(num1: [i.lon, i.lat], num2: [newlon1, newlat1])
                    originstop = i.name
                    originid = i.id
                }
                
                if (destinationmindist > self.getD(num1: [i.lon, i.lat], num2: [newlon2, newlat2])){
                    destinationmindist = self.getD(num1: [i.lon, i.lat], num2: [newlon2, newlat2])
                    destinationstop = i.name
                    originid = i.id
                }
                
            }
        }
        
        

        let shuttle = BUShuttle()
        shuttle.getShuttleData(){ json in
            var wantitsmall = 20 as Int
            var arrivingat = "" as String
            if let ResultSet = json["ResultSet"] as? [String: Any]{
                if let Results = ResultSet["Result"] as? [[String: Any]]{
                    
                    // var index = 0;
                    var PossibleBuses = [Int]()
                    for bus in Results{
                        if let arrivals = bus["arrival_estimates"] as? [[String: Any]]{
                            var count = 0 as Int
                            for busstop in arrivals{
                                let possiblestop = busstop["stop_id"] as! String
                                if (possiblestop == originid && wantitsmall > count){
                                    wantitsmall = count
                                    //  print("Here")
                                    arrivingat = busstop["arrival_at"] as! String
                                    // print(arrivingat)
                                }
                                count = count + 1
                            }
                        }
                        
                    }
                    // print("arrival at")
                    // print(arrivingat)
                    
                    let etatemp = String(arrivingat.suffix(14))
                    // print(etatemp)
                    let eta = String(etatemp.prefix(5))
                    let shuttlelabeltext = "Walk to " + originstop + "\nTake Shuttle arriving at " + eta + "\nGet off at " + destinationstop
                    
                    DispatchQueue.main.async {
                        self.Shuttlelabel.text = shuttlelabeltext
                    }
                    //Now we have possible Bus going in the direction we want as indices in POssibleBuses
                    
                    
                }
            }
            
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
                        print("Want to see seomthing")
                        //                        print(duration)
                        duration = duration / 60
                        let totaltime = self.getETA(duration: Int(duration)) as String
                        
                        //                                let durationstring = String(duration)
                        // print("cool")
                        //                            print(totaltime)
                        //                            print(estimate)
                        //
                        
                        DispatchQueue.main.async {
                            self.uberlabel.text = estimate
                            self.uberlabeleta.text = totaltime
                            
                            
                        }
                        
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
                        let duration = Int(durationflsec/60) as Int
                        let costcent = lyftspec["estimated_cost_cents_max"] as! Float
                        let costdollares = costcent/100 as Float
                        let totaltime = self.getETA(duration: duration) as String
                        DispatchQueue.main.async {
                            
                            self.lyftlabeleta.text = totaltime
                            self.lyftlabel.text = "$" + String(costdollares)
                        }
                        
                        
                        
                    }
                }
            }
        }
        
        // Fetches the bus data, including the ETA, and directions
        cs.getBusData(origin: originstring, destination: destinationstring){json in
            var results: [String] = []
            var ETA = ""
            if let routes = json["routes"] as? [[String: Any]] {
                //                    print(routes)
                for rout in routes {
                    if let legs = rout["legs"] as? [[String: Any]]{
                        for leg in legs{
                            
                            if let ETAstruct = leg["arrival_time"] as? [String: Any]{
                                ETA = ETAstruct["text"] as! String
                                //                                    self.buslabeleta.text = ETA as? String //set text for ETA label
                                //                                }
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
                
                DispatchQueue.main.async {
                    
                    self.buslabel.text = texts
                    self.buslabeleta.text = ETA
                }
            }
        }
        
        // Fetches the Train data, including the ETA, and directions
        cs.getTrainData(origin: originstring, destination: destinationstring){json in
            var results: [String] = []
            var ETA = ""
            if let routes = json["routes"] as? [[String: Any]] {
                ////                    print(routes)
                for rout in routes {
                    if let legs = rout["legs"] as? [[String: Any]]{
                        for leg in legs{
                            
                            if let ETAstruct = leg["arrival_time"] as? [String: Any]{
                                ETA = ETAstruct["text"] as! String //{
                                
                                //                                    self.trainlabeleta.text = ETA as? String //set text for ETA label
                                //                                }
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
                                        let temp = step["html_instructions"] as! String
                                        print(temp)
                                        let myString = String(temp.suffix(temp.count-8))
                                        results.append(myString)
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            var textdetails = results[1] + "\nPick up at: " + results[0] + "\nGet off at: " + results[2]
            DispatchQueue.main.async {
                self.trainlabel.text = textdetails
                self.trainlabeleta.text = ETA
                
            }
        }
        
       // Fetches the walking details, such as the ETA, and the number of streets
        cs.getWalkingData(origin: originstring, destination: destinationstring){json  in
            var results: [String] = []
            var totaltime = ""
            if let routes = json["routes"] as? [[String: Any]] {
                
                for rout in routes {
                    if let legs = rout["legs"] as? [[String: Any]]{
                        for leg in legs{
                            if let timedetails = leg["duration"] as? [String: Any]{
                                let time = timedetails["text"] as! String
                                print("TIME")
                                print(time)
                                var subtime = "" as String
                                if (time.count > 6){
                                    subtime = String(describing: time.prefix(2))
                                }else{
                                    subtime = String(describing: time.prefix(1))
                                }
                                
                                
                                
                                let duration = Int(subtime) as Int!
                                
                                
                                totaltime = self.getETA(duration: duration!)
                                // self.walkinglabeleta.text = totaltime //set text for ETA label
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
                //                self.testingtexts = texts
                DispatchQueue.main.async {
                    
                    self.walkinglabeleta.text = totaltime
                    self.walklabel.text = texts
                }
                
            }
        }
   
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Uber Deeplink
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
    
    // Lyft Deeplink
    @IBAction func lyftbuttonaction(_ sender: Any) {
        let pickup = CLLocationCoordinate2D(latitude: newlat1, longitude: newlon1)
        let destination = CLLocationCoordinate2D(latitude: newlat2, longitude: newlon2)
        LyftDeepLink.requestRide(kind: .Standard, from: pickup, to: destination)
    }
    
 
    // Walking Deeplink
    @IBAction func deepwalking(_ sender: Any) {
        let cs = Transports()
        let deeplink_walking = cs.getgoogleURL(choice: "walking", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_walking)!, options: [:])
    }
    
    // Train Deeplink
    @IBAction func deepT(_ sender: Any) {
        let cs = Transports()
        let deeplink_T = cs.getgoogleURL(choice: "train", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_T)!, options: [:])
    }
    
    // Bus Deeplink
    @IBAction func deepBUs(_ sender: Any) {
        let cs = Transports()
        let deeplink_bushuttle = cs.getgoogleURL(choice: "bus", origin: originstring, destination: destinationstring)
        UIApplication.shared.open(URL(string:
            deeplink_bushuttle)!, options: [:])
    }
    
    
    
}
