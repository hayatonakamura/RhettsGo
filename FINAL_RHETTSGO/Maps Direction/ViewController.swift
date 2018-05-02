//
//  ViewController.swift
//  Maps Direction
//
//  Created by Agus Cahyono on 2/9/17.
//  Copyright © 2017 balitax. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire
import UberRides
import CoreLocation
import LyftSDK
import Foundation

enum Location {
	case startLocation
	case destinationLocation
}

class ViewController: UIViewController , GMSMapViewDelegate ,  CLLocationManagerDelegate {
	
	@IBOutlet weak var googleMaps: GMSMapView!
	@IBOutlet weak var startLocation: UITextField!
	@IBOutlet weak var destinationLocation: UITextField!
    @IBOutlet weak var heart: UIImageView!
    
    //@IBOutlet weak var thelyft: LyftButton!
    var originstring = ""
    var destinationstring = ""
    
	var locationManager = CLLocationManager()
	var locationSelected = Location.startLocation
	
	var locationStart = CLLocation()
	var locationEnd = CLLocation()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        heart.isHidden = true
		
		locationManager = CLLocationManager()
		locationManager.delegate = self
		locationManager.requestWhenInUseAuthorization()
		locationManager.startUpdatingLocation()
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.startMonitoringSignificantLocationChanges()
		
		//Your map initiation code
		let camera = GMSCameraPosition.camera(withLatitude: -7.9293122, longitude: 112.5879156, zoom: 15.0)
		
		self.googleMaps.camera = camera
		self.googleMaps.delegate = self
		self.googleMaps?.isMyLocationEnabled = true
		self.googleMaps.settings.myLocationButton = true
		self.googleMaps.settings.compassButton = true
		self.googleMaps.settings.zoomGestures = true
        
		
	}
	
	// function for create a marker pin on map
	func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2DMake(latitude, longitude)
		marker.title = titleMarker
		marker.icon = iconMarker
		marker.map = googleMaps
	}
	
	//Location Manager delegates
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error to get location : \(error)")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		let location = locations.last
		
		let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
		
		
		self.googleMaps?.animate(to: camera)
		self.locationManager.stopUpdatingLocation()
        
		
	}
	
	// GMSMapViewDelegate
	
	func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
		googleMaps.isMyLocationEnabled = true
	}
	
	func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
		googleMaps.isMyLocationEnabled = true
		
		if (gesture) {
			mapView.selectedMarker = nil
		}
	}
	
	func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
		googleMaps.isMyLocationEnabled = true
		return false
	}
	
	func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
		print("COORDINATE \(coordinate)") // when you tapped coordinate
	}
	
	func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
		googleMaps.isMyLocationEnabled = true
		googleMaps.selectedMarker = nil
		return false
	}
	
	

	//this is function for create direction path, from start location to desination location
	
	func drawPath(startLocation: CLLocation, endLocation: CLLocation)
	{
		let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
		let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
		
  
        
		let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving"
		
		Alamofire.request(url).responseJSON { response in
			
			print(response.request as Any)  // original URL request
			print(response.response as Any) // HTTP URL response
			print(response.data as Any)     // server data
			print(response.result as Any)   // result of response serialization
			
			let json = JSON(data: response.data!)
			let routes = json["routes"].arrayValue
			
			// print route using Polyline
			for route in routes
			{
				let routeOverviewPolyline = route["overview_polyline"].dictionary
				let points = routeOverviewPolyline?["points"]?.stringValue
				let path = GMSPath.init(fromEncodedPath: points!)
				let polyline = GMSPolyline.init(path: path)
				polyline.strokeWidth = 4
				polyline.strokeColor = UIColor.red
				polyline.map = self.googleMaps
			}
			
		}
        
        
	}
	
	// when start location tap, this will open the search location
	@IBAction func openStartLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		// selected location
		locationSelected = .startLocation
		
		// Change text color
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	
	// when destination location tap, this will open the search location
	@IBAction func openDestinationLocation(_ sender: UIButton) {
		
		let autoCompleteController = GMSAutocompleteViewController()
		autoCompleteController.delegate = self
		
		// selected location
		locationSelected = .destinationLocation
		
		// Change text color
		UISearchBar.appearance().setTextColor(color: UIColor.black)
		self.locationManager.stopUpdatingLocation()
		
		self.present(autoCompleteController, animated: true, completion: nil)
	}
	

    
    // Global Variables to parse to the SecondViewController
    var neworigin: String!
    var newdest: String!
    
    var newstart_lat: Double!
    var newstart_lon: Double!
    var newdest_lat: Double!
    var newdest_lon: Double!
    
    
    // Sends information to the SecondViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "SecondViewSegue" || segue.identifier == "SegueFromButton") {
        var second = segue.destination as! SecondViewController
        second.originstring = neworigin
        second.destinationstring = newdest
        second.newlat1 = newstart_lat
        second.newlon1 = newstart_lon
        second.newlat2 = newdest_lat
        second.newlon2 = newdest_lon
            
        second.busString1 = startLocation.text!
        second.busString2 = destinationLocation.text!
        }
    }
    
    
  
    
    // View Details Button
    @IBAction func NextPage(_ sender: Any) {
        print("Details Button Pressed")
        
        // ***
        var lat1 = locationStart.coordinate.latitude as? double_t
        var lon1 = locationStart.coordinate.longitude as? double_t
        var lat2 = locationEnd.coordinate.latitude as? double_t
        var lon2 = locationEnd.coordinate.longitude as? double_t
        var origin:String = String(format:"%f,%f", lat1!,lon1!)
        var destination:String = String(format:"%f,%f", lat2!,lon2!)
        originstring = origin
        destinationstring = destination
        
        // new
        newstart_lat = lat1
        newstart_lon = lon1
        newdest_lat = lat2
        newdest_lon = lon2
        
        neworigin = origin
        newdest = destination
        
        //***
        if (startLocation.text != "" && destinationLocation.text != "") {
            self.performSegue(withIdentifier: "SecondViewSegue", sender: self)
            
        }
    }
    
    // checks if there are user defaults
    func userAlreadyExist(username: String) -> Bool {
        return UserDefaults.standard.object(forKey: username) != nil
    }
    
    
    // Favorites (heart) Button
    @IBAction func favorites(_ sender: Any) {
        if (startLocation.text != "" && destinationLocation.text != "") {
            heart.isHidden = false

            if (userAlreadyExist(username: "origin1") == true) {
                // do nothing
            }
            else {
                UserDefaults.standard.set("", forKey: "origin1")
                UserDefaults.standard.set("", forKey: "dest1")
                UserDefaults.standard.set("", forKey: "slat1")
                UserDefaults.standard.set("", forKey: "slon1")
                UserDefaults.standard.set("", forKey: "dlat1")
                UserDefaults.standard.set("", forKey: "dlon1")

            }
            if (userAlreadyExist(username: "origin2") == true) {
                // do nothing
            }
            else {
                UserDefaults.standard.set("", forKey: "origin2")
                UserDefaults.standard.set("", forKey: "dest2")
                UserDefaults.standard.set("", forKey: "slat2")
                UserDefaults.standard.set("", forKey: "slon2")
                UserDefaults.standard.set("", forKey: "dlat2")
                UserDefaults.standard.set("", forKey: "dlon2")
            }
            if (userAlreadyExist(username: "origin3") == true) {
                // do nothing
            }
            else {
                UserDefaults.standard.set("", forKey: "origin3")
                UserDefaults.standard.set("", forKey: "dest3")
                UserDefaults.standard.set("", forKey: "slat3")
                UserDefaults.standard.set("", forKey: "slon3")
                UserDefaults.standard.set("", forKey: "dlat3")
                UserDefaults.standard.set("", forKey: "dlon3")
            }

            
            var start1: String = UserDefaults.standard.object(forKey: "origin1") as! String
            var start2: String = UserDefaults.standard.object(forKey: "origin2") as! String
            var start3: String = UserDefaults.standard.object(forKey: "origin3") as! String
            
 
            print("favorites clicked!")
            print(start1)
            print(start2)
            print(start3)
            
            if (start1 == "" && start2 == "" && start3 == "") {
                //UserDefaults.standard.removeObject(forKey: "origin1")
                UserDefaults.standard.set(startLocation.text, forKey: "origin1")
                UserDefaults.standard.set(destinationLocation.text, forKey: "dest1")
                UserDefaults.standard.set(locationStart.coordinate.latitude as? double_t, forKey: "slat1")
                UserDefaults.standard.set(locationStart.coordinate.longitude as? double_t, forKey: "slon1")
                UserDefaults.standard.set(locationEnd.coordinate.latitude as? double_t, forKey: "dlat1")
                UserDefaults.standard.set(locationEnd.coordinate.longitude as? double_t, forKey: "dlon1")
                // debugging purposes
                print("first default")
                start1 = UserDefaults.standard.object(forKey: "origin1") as! String
                print(start1)
            }
            else if (start1 != "" && start2 == "" && start3 == "") {
                UserDefaults.standard.set(startLocation.text, forKey: "origin2")
                UserDefaults.standard.set(destinationLocation.text, forKey: "dest2")
                print("second default")
                start2 = UserDefaults.standard.object(forKey: "origin2") as! String
                print(start2)
            }
            else if (start1 != "" && start2 != "" && start3 == "") {
                UserDefaults.standard.set(startLocation.text, forKey: "origin3")
                UserDefaults.standard.set(destinationLocation.text, forKey: "dest3")
                print("third default")
                start3 = UserDefaults.standard.object(forKey: "origin3") as! String
                print(start3)
            }
        }
    }
    
    
    
    
	//SHOW DIRECTION WITH BUTTON
	@IBAction func showDirection(_ sender: UIButton) {
		// when button direction tapped, must call drawpath func
		self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        print("correctly printed")
        print(locationStart.coordinate)
        print(locationEnd.coordinate)
        var lat1 = locationStart.coordinate.latitude as? double_t
        var lon1 = locationStart.coordinate.longitude as? double_t
        var lat2 = locationEnd.coordinate.latitude as? double_t
        var lon2 = locationEnd.coordinate.longitude as? double_t
        var origin:String = String(format:"%f,%f", lat1!,lon1!)
        var destination:String = String(format:"%f,%f", lat2!,lon2!)
        originstring = origin
        destinationstring = destination
        print("sup")
        print(originstring)
        
        // new
        newstart_lat = lat1
        newstart_lon = lon1
        newdest_lat = lat2
        newdest_lon = lon2
        
        neworigin = origin
        newdest = destination
	}

}

//GMS Auto Complete Delegate, for autocomplete search location
extension ViewController: GMSAutocompleteViewControllerDelegate {
	
	func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
		print("Error \(error)")
	}
	
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		
		// Change map location
		let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
		)
		
		// set coordinate to text
		if locationSelected == .startLocation {
//            startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            startLocation.text = place.formattedAddress
			locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		} else {
//            destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            destinationLocation.text = place.formattedAddress
			locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		}
		
		
		self.googleMaps.camera = camera
		self.dismiss(animated: true, completion: nil)
		
	}
	
	func wasCancelled(_ viewController: GMSAutocompleteViewController) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
	}
	
	func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
	}
	
}

public extension UISearchBar {
	
	public func setTextColor(color: UIColor) {
		let svs = subviews.flatMap { $0.subviews }
		guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
		tf.textColor = color
	}
	
}
