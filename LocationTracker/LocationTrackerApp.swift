import Combine
import SwiftUI

@main
struct LocationTrackerApp: App {
    let locationPublisher = LocationPublisher()
    var cancellables = [AnyCancellable]()
    
    init() {
        /// This connects LocationPublisher and PersistenceController with help of Combine
     locationPublisher.sink(receiveValue: PersistenceController.shared.add).store(in: &cancellables)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
