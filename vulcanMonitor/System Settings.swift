//
//  System Settings.swift
//  vulcanDetector
//
//  Created by Park Seyoung on 11/09/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import Foundation

struct Constants {
    static let serverURL = "https://powerful-oasis-83494.herokuapp.com/seyoung-iphone"
    static let zoomLevel: Double = 18
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