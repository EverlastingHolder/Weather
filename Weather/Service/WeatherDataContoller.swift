import Foundation
import CoreData

class WeatherDataContoller {
    static let shared = WeatherDataContoller()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "WeatherCoreData")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
}
