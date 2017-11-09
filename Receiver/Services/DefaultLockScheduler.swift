import Foundation

/// Default implementation of LockScheduler protocol.
/// - note: This class is not thread-safe, make sure you always call its methods
/// from one thread.
public class DefaultLockScheduler: LockScheduler {
	private let proximityMonitor: LockProximityMonitor
	private let lockAPI: LockAPI
	private var interval: TimeInterval = 4.0
    private var timer: DispatchSourceTimer?

    public required init(
    		with proximityMonitor: LockProximityMonitor, lockAPI: LockAPI) {
        
    	self.proximityMonitor = proximityMonitor
     	self.lockAPI = lockAPI
    }
    
    public func start(with interval: DispatchTimeInterval) {
        guard self.timer == nil else {
            // Timer already running
            return
        }

        self.timer = DispatchSource.repeatableTimer(interval: interval) {
            [weak self] in
            
            guard let s = self else { return }
            s.process()
        }
    }
    
    public func stop() {
    	self.timer?.cancel()
    }
    
    private func process() {
        print("Checking lock proximity...")
        if self.proximityMonitor.currentProximity == .immediate {
            // We're close to the lock, make the call
            print("Lock detected, unlocking...")
            self.lockAPI.unlock()
        }
    }
}

public extension DispatchSource {
    /// Convenience factory for timer sources
	public class func repeatableTimer(
            interval: DispatchTimeInterval,
            queue: DispatchQueue = DispatchQueue.main,
            leeway: DispatchTimeInterval = .nanoseconds(0),
            handler: @escaping () -> Void) -> DispatchSourceTimer {
        
        let result = DispatchSource.makeTimerSource(queue: queue)
        
        result.setEventHandler(handler: handler)
        result.schedule(
                deadline: DispatchTime.now() + interval,
                repeating: interval,
                leeway: leeway)
        result.resume()
        
        return result
      }
}
