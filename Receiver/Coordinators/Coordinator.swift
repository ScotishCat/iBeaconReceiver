import Foundation

/**
 A protocol for coordinators.
 
 Coordinator is an object that ties together various
 components and one or more view controllers to implement specific use case (for example,
 it can be an app or "root" coordinator that manages high-level application logic,
 or it can manage onboarding, sign-in etc.). This allows to move all complex application
 logic to designated objects, which are easily testable by injecting appropriate dependencies.
 It also allows making "thin" and highly reusable view controllers, that are tightly focused
 or their main job - visual presentation and integration with the OS.
*/
public protocol Coordinator: class {
    func start()
    func cleanup()
}
