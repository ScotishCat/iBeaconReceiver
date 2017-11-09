import Foundation

public protocol LockScheduler: class {
	init(with proximityMonitor: LockProximityMonitor, lockAPI: LockAPI)
	
	func start(with interval: DispatchTimeInterval)
	func stop()
}
