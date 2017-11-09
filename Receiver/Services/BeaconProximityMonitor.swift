import Foundation
import CoreLocation

public struct BeaconItem: MonitoringItem {
	public let name: String
	public let identifier: String
	public let majorID: UInt16
	public let minorID: UInt16
}

public class BeaconProximityMonitor: NSObject, LockProximityMonitor {
    public private(set) var currentProximity: LockProximity = .unknown
    
    private let item: MonitoringItem
    private var enteredHandler: LockProximityHandler?
    private var exitedHandler: LockProximityHandler?
    private var monitoredProximity: LockProximity = .unknown
    
    private let locationManager: CLLocationManager

	public init(with item: MonitoringItem, locationManager: CLLocationManager) {
        self.item = item
        self.locationManager = locationManager

		super.init()
        
  		self.locationManager.delegate = self
  		self.locationManager.requestAlwaysAuthorization()
    }

    public required convenience init(with item: MonitoringItem) {
		self.init(with: item, locationManager: CLLocationManager())
	}
	
	public func startMonitoring(for proximity: LockProximity,
            enteredHandler: @escaping LockProximityHandler,
            exitedHandler: @escaping LockProximityHandler) {
		
		if !(CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)) {
            print("Couldn't turn on region monitoring: Region monitoring is not available for CLBeaconRegion class.")
            self.currentProximity = .unknown
            return
        }
        
		guard let beaconRegion = self.item.asBeaconRegion() else {
  			print("Failed to convert item to a CLBeaconRegion!")
            return
        }
        
        self.monitoredProximity = proximity
        self.enteredHandler = enteredHandler
        self.exitedHandler = exitedHandler
        self.locationManager.startMonitoring(for: beaconRegion)
        self.locationManager.startRangingBeacons(in: beaconRegion)
	}
	
	public func stopMonitoring() {
        guard let beaconRegion = self.item.asBeaconRegion() else {
            print("Failed to convert item to a CLBeaconRegion!")
            return
        }
        
        self.enteredHandler = nil
        self.exitedHandler = nil
        
        self.monitoredProximity = .unknown
		self.locationManager.stopMonitoring(for: beaconRegion)
  		self.locationManager.stopRangingBeacons(in: beaconRegion)
	}
}

extension MonitoringItem {
	func asBeaconRegion() -> CLBeaconRegion? {
		guard let uuid = UUID(uuidString: self.identifier) else {
  			assertionFailure("Failed to convert identifier \(self.identifier) to UUID")
     		return nil
        }
        
        let result = CLBeaconRegion(proximityUUID: uuid,
                major: CLBeaconMajorValue(self.majorID),
            minor: CLBeaconMinorValue(self.minorID),
            identifier: self.name)
        result.notifyEntryStateOnDisplay = true
		return result
    }
}

extension BeaconProximityMonitor: CLLocationManagerDelegate {
	
	public func locationManager(_ manager: CLLocationManager,
			didEnterRegion region: CLRegion) {
		
  		print("Did entered region!")
	}

    public func locationManager(_ manager: CLLocationManager,
            didExitRegion region: CLRegion) {
        
    	print("Did exited region!")
     	self.currentProximity = .unknown
    }

	public func locationManager(_ manager: CLLocationManager,
			didRangeBeacons beacons: [CLBeacon],
        	in region: CLBeaconRegion) {
     	
		guard let beacon = beacons.first else {
  			if self.currentProximity != .unknown {
     			self.exitedHandler?()
            }
            self.currentProximity = .unknown
            
  			return
        }
        
        let proximity = LockProximity.from(beacon.proximity)
  		if self.currentProximity != proximity {
    		if proximity == self.monitoredProximity {
      			self.enteredHandler?()
            } else {
            	self.exitedHandler?()
            }
        }
    	self.currentProximity = proximity
    }

    public func locationManager(_ manager: CLLocationManager,
                                didDetermineState state: CLRegionState,
                                for region: CLRegion) {
        
        let stateString: String

        switch state {
        case .inside:
            stateString = "inside"
        case .outside:
            stateString = "outside"
        case .unknown:
            stateString = "unknown"
        }

        print("State changed to " + stateString + " for region \(region).")
    }

    public func locationManager(_ manager: CLLocationManager,
            monitoringDidFailFor region: CLRegion?,
            withError error: Error) {
        
    	print("Failed monitoring region: \(error.localizedDescription)")
    }
  
    public func locationManager(_ manager: CLLocationManager,
    		didFailWithError error: Error) {

		print("Location manager failed: \(error.localizedDescription)")
	}
}

extension LockProximity {
	static func from(_ clProximity: CLProximity) -> LockProximity {
		switch clProximity {
            case .unknown:
                return .unknown
            case .near:
                return .near
            case .immediate:
                return .immediate
            case .far:
                return .far
        }
    }
}
