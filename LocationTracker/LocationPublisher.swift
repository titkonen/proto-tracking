//import Combine
//import CoreLocation
//import Foundation
//
//class LocationPublisher: NSObject {
//    
//    typealias Output = (longitude: Double, latitude: Double)
//    typealias Failure = Never
//    
//    private let wrapped = PassthroughSubject<(Output), Failure>()
//    
//    private let locationManager = CLLocationManager()
//    
//    override init() {
//        super.init()
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.activityType = .fitness
//        //self.locationManager.requestAlwaysAuthorization()
//        self.locationManager.allowsBackgroundLocationUpdates = true
//        self.locationManager.pausesLocationUpdatesAutomatically = false // throws "Non-UI clients cannot be autopaused"
//        //self.locationManager.startUpdatingLocation()
//    }
//  
//  
//}
//
//extension LocationPublisher: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        wrapped.send((longitude: location.coordinate.longitude, latitude: location.coordinate.latitude))
//    }
//}
//
//extension LocationPublisher: Publisher {
//    func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
//        wrapped.subscribe(subscriber)
//    }
//}
