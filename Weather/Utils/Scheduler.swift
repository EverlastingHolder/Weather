import Foundation

final class Scheduler {
    static var background: OperationQueue = {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 5
        queue.qualityOfService = QualityOfService.userInitiated
        
        return queue
    }()
    
    static var main: RunLoop = RunLoop.main
}
