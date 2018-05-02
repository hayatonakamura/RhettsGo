//
//  newViewFavorites.swift
//  MapsDirection
//
//  Created by Hayato Nakamura on 2018/05/01.
//  Copyright © 2018 balitax. All rights reserved.
//

import Foundation
import UIKit

class newViewFavorites: UIViewController {
    
    @IBOutlet weak var s1: UILabel!
    @IBOutlet weak var d1: UILabel!
    @IBOutlet weak var s2: UILabel!
    @IBOutlet weak var d2: UILabel!
    @IBOutlet weak var s3: UILabel!
    @IBOutlet weak var d3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        s1.text = UserDefaults.standard.object(forKey: "origin1") as? String
        s2.text = UserDefaults.standard.object(forKey: "origin2") as? String
        s3.text = UserDefaults.standard.object(forKey: "origin3") as? String
        d1.text = UserDefaults.standard.object(forKey: "dest1") as? String
        d2.text = UserDefaults.standard.object(forKey: "dest2") as? String
        d3.text = UserDefaults.standard.object(forKey: "dest3") as? String
        
        
        if (s1.text == "" || s1.text == nil) {
            s1.text = "Empty"
        }
        if (s2.text == "" || s2.text == nil) {
            s2.text = "Empty"
        }
        if (s3.text == "" || s3.text == nil) {
            s3.text = "Empty"
        }
        
    }
    
    // Clear favorites button
    @IBAction func clearbutton(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        s1.text = "Empty"
        s2.text = ""
        s3.text = ""
        d1.text = ""
        d2.text = ""
        d3.text = ""
    }
    
    
    // segue variables
    var neworigin: String!
    var newdest: String!
    
    var newstart_lat: Double!
    var newstart_lon: Double!
    var newdest_lat: Double!
    var newdest_lon: Double!
    
    var clicked: Int! = 0
    
    // Back button
    @IBAction func backbutton(_ sender: Any) {
        self.performSegue(withIdentifier: "back", sender: self)

    }
    
    // Sends information to the SecondViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let second = segue.destination as? SecondViewController {
            second.originstring = neworigin
            second.destinationstring = newdest
            second.newlat1 = newstart_lat
            second.newlon1 = newstart_lon
            second.newlat2 = newdest_lat
            second.newlon2 = newdest_lon
        }
        else {
            
        }


    }
    
    // Favorite 1 Button is pressed
    @IBAction func search1(_ sender: Any) {
        var lat1 = UserDefaults.standard.object(forKey: "slat1") as? Double
        print(lat1)
        var lon1 = UserDefaults.standard.object(forKey: "slon1") as? Double
        print(lon1)
        var lat2 = UserDefaults.standard.object(forKey: "dlat1") as? Double
        var lon2 = UserDefaults.standard.object(forKey: "dlon1") as? Double
        if (lat1 != nil) {
        let origin:String = String(format:"%f,%f", lat1!,lon1!)
        let destination:String = String(format:"%f,%f", lat2!,lon2!)
        
        // new
        newstart_lat = lat1 as! Double
        newstart_lon = lon1 as! Double
        newdest_lat = lat2 as! Double
        newdest_lon = lon2 as! Double
        
        neworigin = origin as! String
        newdest = destination as! String
        

        self.performSegue(withIdentifier: "favorites_segue", sender: self)
        clicked = 0;
        print(clicked)
        }
        
    }
    
    // Favorite 2 Button is pressed
    @IBAction func search2(_ sender: Any) {
        var lat1 = UserDefaults.standard.object(forKey: "slat2") as? Double
        print(lat1)
        var lon1 = UserDefaults.standard.object(forKey: "slon2") as? Double
        print(lon1)
        var lat2 = UserDefaults.standard.object(forKey: "dlat2") as? Double
        var lon2 = UserDefaults.standard.object(forKey: "dlon2") as? Double
        if (lat1 != nil) {
        let origin:String = String(format:"%f,%f", lat1!,lon1!)
        let destination:String = String(format:"%f,%f", lat2!,lon2!)
        
        // new
        newstart_lat = lat1 as! Double
        newstart_lon = lon1 as! Double
        newdest_lat = lat2 as! Double
        newdest_lon = lon2 as! Double
        
        neworigin = origin as! String
        newdest = destination as! String
        
        clicked = 0;
        self.performSegue(withIdentifier: "favorites_segue", sender: self)
        }
    }
    
    // Favorite 3 button is pressed
    @IBAction func search3(_ sender: Any) {
        var lat1 = UserDefaults.standard.object(forKey: "slat3") as? Double
        print(lat1)
        var lon1 = UserDefaults.standard.object(forKey: "slon3") as? Double
        print(lon1)
        var lat2 = UserDefaults.standard.object(forKey: "dlat3") as? Double
        var lon2 = UserDefaults.standard.object(forKey: "dlon3") as? Double
        if (lat1 != nil) {
        let origin:String = String(format:"%f,%f", lat1!,lon1!)
        let destination:String = String(format:"%f,%f", lat2!,lon2!)
        
        // new
        newstart_lat = lat1 as! Double
        newstart_lon = lon1 as! Double
        newdest_lat = lat2 as! Double
        newdest_lon = lon2 as! Double
        
        neworigin = origin as! String
        newdest = destination as! String
        
        clicked = 0;
        self.performSegue(withIdentifier: "favorites_segue", sender: self)
        }
    }
    
}
