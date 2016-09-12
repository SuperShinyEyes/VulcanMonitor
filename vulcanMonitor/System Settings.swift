//
//  System Settings.swift
//  vulcanDetector
//
//  Created by Park Seyoung on 11/09/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import Foundation
import MapKit

struct Constants {
    static let serverURL = "https://powerful-oasis-83494.herokuapp.com/seyoung-iphone"
    static let zoomLevel: Double = 18
    static let libraryCoordinate = CLLocationCoordinate2D(latitude: 40.022332, longitude: -75.190843)
    static let schollerHallCoordinate = CLLocationCoordinate2D(latitude: 40.022377, longitude:  -75.193627)
    static let philadelphiaCoordinate = CLLocationCoordinate2D(latitude:  39.952584, longitude: -75.165222)
    static let philaUCoordinate = CLLocationCoordinate2D(latitude:  40.023318, longitude: -75.194271)

}

enum VibrationStatus: String {
    case Steady = "sleeping"
    case Earthquake = "weary"
    
    static let normal = "sleeping"
    static let earthquake = "weary"
}

enum EarthquakeMagnitude: String {
    case Strong = "red"
    case Medium = "orange"
    case Mild = "yellow"
    case Steady = "green"
    
    init(colorAsString: String) {
        switch colorAsString {
        case "red": self = .Strong
        case "orange": self = .Medium
        case "yellow": self = .Mild
        default: self = .Steady
        }
    }
}