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
	
    @IBOutlet weak var thelyft: LyftButton!
    
	var locationManager = CLLocationManager()
	var locationSelected = Location.startLocation
	
	var locationStart = CLLocation()
	var locationEnd = CLLocation()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
        
        let builder = RideParametersBuilder()
        let pickupLocation = CLLocation(latitude: 42.352069, longitude: -71.115538)
        let dropoffLocation = CLLocation(latitude: 42.349363, longitude: -71.106725)
        builder.pickupLocation = pickupLocation
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = "Photonics"
        builder.dropoffAddress = "8 St. Marys st"
        let rideParameters = builder.build()
        //let deeplink = RequestDeeplink(rideParameters: rideParameters, fallbackType: .mobileWeb)
        let button = RideRequestButton(rideParameters: rideParameters)
        
        button.frame.origin = CGPoint(x: 25, y: 535)
        // changing button size
        //button.frame.size = CGSize(width: 280.0, height: 50.0)
        view.addSubview(button)
        let pickup = CLLocationCoordinate2D(latitude: 42.352069, longitude: -71.115538)
        let destination = CLLocationCoordinate2D(latitude: 42.349363, longitude: -71.106725)
        thelyft.configure(rideKind: LyftSDK.RideKind.Standard, pickup: pickup, destination: destination)
		
	}
	
	// MARK: function for create a marker pin on map
	func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2DMake(latitude, longitude)
		marker.title = titleMarker
		marker.icon = iconMarker
		marker.map = googleMaps
	}
	
	//MARK: - Location Manager delegates
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Error to get location : \(error)")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		let location = locations.last
		
//		let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
		
		let locationTujuan = CLLocation(latitude: 37.784023631590777, longitude: -122.40486681461333)
		
		createMarker(titleMarker: "Lokasi Tujuan", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: locationTujuan.coordinate.latitude, longitude: locationTujuan.coordinate.longitude)
		
		createMarker(titleMarker: "Lokasi Aku", iconMarker: #imageLiteral(resourceName: "mapspin") , latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
		
		drawPath(startLocation: location!, endLocation: locationTujuan)
		
//		self.googleMaps?.animate(to: camera)
		self.locationManager.stopUpdatingLocation()
        
		
	}
	
	// MARK: - GMSMapViewDelegate
	
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
	
	

	//MARK: - this is function for create direction path, from start location to desination location
	
	func drawPath(startLocation: CLLocation, endLocation: CLLocation)
	{
		let origin = "\(startLocation.coordinate.latitude),\(startLocation.coordinate.longitude)"
		let destination = "\(endLocation.coordinate.latitude),\(endLocation.coordinate.longitude)"
		
        let builder = RideParametersBuilder()
        let pickupLocation = CLLocation(latitude: 42.352069, longitude: -71.115538)
        let dropoffLocation = CLLocation(latitude: 42.349363, longitude: -71.106725)
        builder.pickupLocation = pickupLocation
        builder.dropoffLocation = dropoffLocation
        builder.dropoffNickname = "Photonics"
        builder.dropoffAddress = "8 St. Marys st"
        let rideParameters = builder.build()
        //let deeplink = RequestDeeplink(rideParameters: rideParameters, fallbackType: .mobileWeb)
        let button = RideRequestButton(rideParameters: rideParameters)
        
        button.frame.origin = CGPoint(x: 25, y: 535)
        // changing button size
        //button.frame.size = CGSize(width: 280.0, height: 50.0)
        view.addSubview(button)
        //let pickup = CLLocationCoordinate2D(latitude: 42.352069, longitude: -71.115538)
        //let destination = CLLocationCoordinate2D(latitude: 42.349363, longitude: -71.106725)
        thelyft.configure(rideKind: LyftSDK.RideKind.Standard, pickup: startLocation.coordinate, destination: endLocation.coordinate)
        
        
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
	
	// MARK: when start location tap, this will open the search location
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
	
	// MARK: when destination location tap, this will open the search location
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
	
	
    // View Details Button
    @IBAction func NextPage(_ sender: Any) {
        print("Button Pressed")
        if (startLocation.text != "" && destinationLocation.text != "") {
        self.performSegue(withIdentifier: "SecondViewSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var second = segue.destination as! SecondViewController
        second.busString1 = startLocation.text!
        second.busString2 = destinationLocation.text!
    }
    
    
    
	// MARK: SHOW DIRECTION WITH BUTTON
	@IBAction func showDirection(_ sender: UIButton) {
		// when button direction tapped, must call drawpath func
		self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        print("SUp bitch")
        print(locationStart.coordinate)
        print(locationEnd.coordinate)
        var lat1 = locationStart.coordinate.latitude as? double_t
        var lon1 = locationStart.coordinate.longitude as? double_t
        var lat2 = locationEnd.coordinate.latitude as? double_t
        var lon2 = locationEnd.coordinate.longitude as? double_t
        var origin:String = String(format:"%f,%f", lat1!,lon1!)
        var destination:String = String(format:"%f,%f", lat2!,lon2!)
        // Do any additional setup after loading the view, typically from a nib.
        //        let origin = "42.3493,-71.1040"
        //        let destination = "42.3483,-71.1381"
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
                for i in results{
                    print(i)
                }
            }
            catch {
                print("Error")
            }
            
        }
        task.resume()
        for i in results{
            print(i)
        }
        // end
	}

}

// MARK: - GMS Auto Complete Delegate, for autocomplete search location
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
			startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
			locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
			createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "mapspin"), latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
		} else {
			destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
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
