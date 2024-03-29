import CoreData
import CoreLocationUI
import Foundation
import MapKit
import SwiftUI
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Location.timestamp, ascending: true)],
        animation: .default)
    private var locations: FetchedResults<Location>
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.1699, longitude: 24.9384),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

    // MARK: TEMP
    @StateObject var viewModel = ContentViewModel() // Links Class from bottom
  
    var body: some View {
        ZStack {
            map
          VStack {
            LocationButton(.currentLocation) {
              viewModel.requestAllowOnceLocationPermission()
            }
            HStack {
              clearButton
              startButton
              stopButton
            }
          }
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
    }
    private var map: some View {
        Map(coordinateRegion: $region,
            interactionModes: .all,
            showsUserLocation: true,
            userTrackingMode: .constant(.follow),
            annotationItems: locations) { location in
            
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                Circle().fill(Color.blue).frame(width: 10, height: 10)
            }
        }
    }
    
    private var clearButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    clearAllLocations()
                }, label: {
                    Image(systemName: "trash")
                        .font(.system(.title2))
                        .frame(width: 57, height: 50)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                })
                .background(Color.blue)
                .cornerRadius(28.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
            }
        }
    }
  
    private var startButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                  startTracking()
                }, label: {
                    Image(systemName: "plus")
                        .font(.system(.title2))
                        .frame(width: 57, height: 50)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                })
                .background(Color.green)
                .cornerRadius(28.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
            }
        }
    }
  
    private var stopButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    stopTracking()
                }, label: {
                    Image(systemName: "stop")
                        .font(.system(.title2))
                        .frame(width: 57, height: 50)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                })
                .background(Color.red)
                .cornerRadius(28.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),radius: 3,x: 3,y: 3)
            }
        }
    }
  
    // MARK: Functions
    private func startTracking() {
      print("Start Tracking button pressed")
      viewModel.startLocationTracking()
    }
    
    private func stopTracking() {
      print("Stop Tracking button pressed")
      viewModel.stopLocationTracking()
    }
    
    private func clearAllLocations() {
        locations.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

// ViewModel Class
final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  @Published var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 40, longitude: 120),
    span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))
 
  let locationManager = CLLocationManager()
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func requestAllowOnceLocationPermission() {
    locationManager.requestLocation()
    print("requestAllowOnceLocationPermission")
  }
  
  func startLocationTracking() {
    locationManager.startUpdatingLocation()
    print("startLocationTracking pressed")
  }
  
  func stopLocationTracking() {
    locationManager.stopUpdatingLocation()
    print("stopLocationTracking pressed")
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let latestLocation = locations.first else {
      return
    }
    
    DispatchQueue.main.async {
      self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
    print(latestLocation.coordinate)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
}
