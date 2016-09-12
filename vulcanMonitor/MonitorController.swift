//
//  ViewController.swift
//  vulcanMonitor
//
//  Created by Park Seyoung on 11/09/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import UIKit
import Mapbox

class MonitorController: UIViewController, MGLMapViewDelegate {
    
    var requestTimer: NSTimer!
    var mapView: MGLMapView!
    var detectorAnnotation = MGLPointAnnotation()
    
    var detectorAnnotationTitle: String = "1 person"
    var detectorAnnotationSubtitle: String = "dummy sub"
    var earthquakeMagnitude = EarthquakeMagnitude.Strong
    
    var coordinate: CLLocationCoordinate2D? {
        willSet {
            mapView.removeAnnotation(detectorAnnotation)
        }
        didSet {
            guard let coord = coordinate else { return }
            detectorAnnotation.coordinate = coord
            detectorAnnotation.title = detectorAnnotationTitle
            detectorAnnotation.subtitle = detectorAnnotationSubtitle
            mapView.addAnnotation(detectorAnnotation)
            zoomIn(coord)
        }
    }
    
    
    
    private func zoomIn(coord: CLLocationCoordinate2D, zoomLevel: Double = Constants.zoomLevel) {
        mapView.setCenterCoordinate(coord, zoomLevel: zoomLevel, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadMapView()
        loadRequestTimer()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadButton()
    }
    
    override func viewDidDisappear(animated: Bool) {
        requestTimer.invalidate()
    }
    
    private func loadRequestTimer() {
        requestTimer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(getVulcanData), userInfo: nil, repeats: true)
    }
    
    private func loadMapView(){
        mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        view.addSubview(mapView)
        mapView.delegate = self
    }
    
    func updateCoordinate(longitudeAsString: String, latitudeAsString: String) {
        guard let longitude = Double(longitudeAsString),
            latitude = Double(latitudeAsString)
            else { return }
        
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var i = 0
    func getVulcanData(){
        print("getVulcanData #\(i)")
        i += 1
        guard let url = NSURL(string: Constants.serverURL) else { return }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print("convertedJsonIntoDict: \(convertedJsonIntoDict)")
                    
                    // Get value by key
                    let longitude = convertedJsonIntoDict["longitude"] as? String
                    let latitude = convertedJsonIntoDict["latitude"] as? String
                    let magnitude = convertedJsonIntoDict["magnitude"] as? String
                    
                    
                    if let longitude = longitude,
                        latitude = latitude,
                        magnitude = magnitude {
                        self.updateCoordinate(longitude, latitudeAsString: latitude)
                    }
                    
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
        }
        //        }
        
        task.resume()
        
    }
    
    private func updateMagnitudeState(magnitudeColor: String) {
        earthquakeMagnitude = EarthquakeMagnitude(colorAsString: magnitudeColor)
    }
    
    private func loadButton(){
        let button = UIButton(type: .System) // let preferred over var here
        let width: CGFloat = 200
        let height: CGFloat = 100
        let padding: CGFloat = 20
        button.frame = CGRectMake(view.bounds.width - width - padding,
                                  view.bounds.height - height - padding,
                                  width,
                                  height)
        button.backgroundColor = UIColor.greenColor()
        button.setTitle("Request", forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(getVulcanData), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        view.bringSubviewToFront(button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(mapView: MGLMapView, viewForAnnotation annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        print(annotation.title)
        return true
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier(earthquakeMagnitude.rawValue)
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: earthquakeMagnitude.rawValue)!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: earthquakeMagnitude.rawValue)
        }
        
        return annotationImage
    }
}

