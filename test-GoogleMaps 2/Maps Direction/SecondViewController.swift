//
//  SecondViewController.swift
//  MapsDirection
//
//  Created by Hayato Nakamura on 2018/04/11.
//  Copyright © 2018 balitax. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var buslabel: UILabel!
    @IBOutlet weak var trainlabel: UILabel!
    @IBOutlet weak var walklabel: UILabel!
    
    var busString1 = String()
    var busString2 = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // If we want to display text
        //buslabel.text = busString1

        walklabel.text = "40 mins  1.8 mi  Head west on Commonwealth Avenue toward Cummington Mall Slight left to stay on Commonwealth Avenue Destination will be on the left"
        
        trainlabel.text = "19 min Walk to Boston University East Station Take Green Line B heading towards Boston College and get off at Allston Street Station  Walk to 1400 Commonwealth Avenue, Boston, MA 02134, USA"
        
        buslabel.text = "22 mins Walk to Commonwealth Ave @ Granby St Take Bus towards Watertown Yard, # 57 Watertown Yard Walk to 1400 Commonwealth Avenue, Boston, MA 02134, USA"
        
        
        
        
        
        
        
    
        // Do any additional setup after loading the view, typically from a nib.
        //        let origin = "42.3493,-71.1040"
        //        let destination = "42.3483,-71.1381"
        var stringarr = busString1.components(separatedBy: " ")
        let lat1 = stringarr[0]
        let lon1 = stringarr[1]
        
        var stringarr2 = busString2.components(separatedBy: " ")
        let lat2 = stringarr2[0]
        let lon2 = stringarr2[1]
        
        
        let jsonURLString = "https://maps.googleapis.com/maps/api/directions/json?"
        let key = "AIzaSyAYQYjp_C4gySyTcGvSlV2VgQu8gz6KTzE"
        let urlstring = jsonURLString + "origin=" + lat1 + "," + lon1 + "&destination=" + lat2 + "," + lon2 + "&key=" + key + "&mode=transit&transit_mode=bus"
        
        
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
                    if let routes = json["routes"] as? [[String: Any]] {
                        //                    print(routes)
                        for rout in routes {
                            if let legs = rout["legs"] as? [[String: Any]]{
                                for leg in legs{
                                    if let duration = leg["duration"] as? [String: Any]{
                                        let temp = duration["text"] as? String
                                        results.append(temp!)
                                    }
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
                                                let temp2 = "Take " + instruction! + ", # "
                                                temp = temp2 + busnumber! + " " + bustitle!
                                            }
                                            else {
                                                temp = step["html_instructions"] as? String
                                            }
                                            results.append(temp!)
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
                var finalstring:String = ""
                for i in results{
                    finalstring = finalstring + i
                }
                //self.buslabel.text = finalstring
            }
            catch {
                print("Error")
            }
            
        }
        task.resume()
//        for i in results{
//            print(i)
     //   }
        // end
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
