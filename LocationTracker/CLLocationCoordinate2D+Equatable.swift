//
//  CLLocationCoordinate2D+Equatable.swift
//  LocationTracker
//
//  Created by Tobias Wissmüller on 18.05.21.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
