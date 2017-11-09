import Foundation

public enum LockProximity {
	case unknown
	case immediate // Within centimeters
	case near // Withing meters
	case far // More than 10 meters away
}

public protocol MonitoringItem {
	var name: String { get }
	var identifier: String { get }
    var majorID: UInt16 { get }
    var minorID: UInt16 { get }
}

public typealias LockProximityHandler = ()->Void
public protocol LockProximityMonitor: class {
    
    var currentProximity: LockProximity { get }
    
    init(with item: MonitoringItem)
    
    func startMonitoring(for proximity: LockProximity,
    	enteredHandler: @escaping LockProximityHandler,
        exitedHandler: @escaping LockProximityHandler)
    
    func stopMonitoring()
}
