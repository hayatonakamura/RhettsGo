//
//  newSecondViewController.swift
//  MapsDirection
//
//  Created by Hayato Nakamura on 2018/04/28.
//  Copyright © 2018 balitax. All rights reserved.
//


import Foundation
import UIKit
import LyftSDK
import SwiftyJSON
import Alamofire
import UberRides
import CoreLocation

class newSecondViewController: UIViewController {
    
    @IBOutlet weak var buslabel: UILabel!
    @IBOutlet weak var trainlabel: UILabel!
    @IBOutlet weak var walklabel: UILabel!
    @IBOutlet weak var lyftbutton_b: LyftButton!
    @IBOutlet weak var walkinglabeleta: UILabel!
    
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
        builder.dropoffNickname = "Photonics"
        builder.dropoffAddress = "8 St. Marys st"
        let rideParameters = builder.build()
        //let deeplink = RequestDeeplink(rideParameters: rideParameters, fallbackType: .mobileWeb)
        let button = RideRequestButton(rideParameters: rideParameters)
        
        button.frame.origin = CGPoint(x: 25, y: 130)
        // changing button size
        //button.frame.size = CGSize(width: 280.0, height: 50.0)
        view.addSubview(button)
        let pickup = CLLocationCoordinate2D(latitude: newlat1, longitude: newlon1)
        let destination = CLLocationCoordinate2D(latitude: newlat2, longitude: newlon2)
        lyftbutton_b.configure(rideKind: LyftSDK.RideKind.Standard, pickup: pickup, destination: destination)
        
        print("Andreas")
        print("Origin:")
        //print(originstring)
        print("Destination:")
        //print(destinationstring)
        print("done")
        
        //        walklabel.text = "40 mins 1.8 mi  Head west on Commonwealth Avenue toward Cummington Mall Slight left to stay on Commonwealth Avenue Destination will be on the left"
        //
        //        trainlabel.text = "19 min Walk to Boston University East Station Take Green Line B heading towards Boston College and get off at Allston Street Station  Walk to 1400 Commonwealth Avenue, Boston, MA 02134, USA"
        //
        //        buslabel.text = "22 mins Walk to Commonwealth Ave @ Granby St Take Bus towards Watertown Yard, # 57 Watertown Yard Walk to 1400 Commonwealth Avenue, Boston, MA 02134, USA"
        
        let cs = Transports()
        cs.getBusData(biglabel: buslabeleta, detailedlabel: buslabel, origin: originstring, destination: destinationstring){_ in
            print("bus good")
        }
        cs.getTrainData(biglabel: trainlabeleta, detailedlabel: trainlabel, origin: originstring, destination: destinationstring){_ in
            print("train good")
        }
        
        cs.getWalkingData(biglabel: walkinglabeleta, detailedlabel: walklabel, origin: originstring, destination: destinationstring){_ in
            print("walking good")
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //        let origin = "42.3493,-71.1040"
        //        let destination = "42.3483,-71.1381"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
