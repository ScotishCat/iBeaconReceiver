import Foundation
import UIKit

/// Root application coordinator that manages high-level application flow.
public class AppCoordinator: Coordinator {
    var mainWindow: UIWindow!
    var tabController: UITabBarController!

    var proximityMonitor: LockProximityMonitor!
    var scheduler: LockScheduler!
    var lockAPI: LockAPI!
    
    lazy var lockViewController: LockViewController = self.createLockController()

    public init(
            with window: UIWindow,
            launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        self.mainWindow = window
        self.tabController = UITabBarController()
        self.tabController.viewControllers = [
                self.lockViewController,
                self.createProfileController()]
        self.mainWindow.rootViewController = self.tabController
    }

    public func start() {
        self.setUp()
    }
    
    public func cleanup() {
        // no-op
    }
    
    public func applicationWillEnterForeground() {
        let splashController: SplashScreenController? =
            Storyboard.main.instantiateViewController()
        self.mainWindow.rootViewController = splashController
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(4)) {
            
            self.tabController.viewControllers = [
                self.lockViewController, self.createProfileController()]
            self.mainWindow.rootViewController = self.tabController
        }
    }
    
    private func createProfileController() -> UIViewController {
        let profile = UserProfile(
                name: "Bryan Chaffin",
                picture: UIImage(named: "Image")!)
        let profileScreen: ProfileViewController? =
            Storyboard.main.instantiateViewController()
        profileScreen?.userProfile = profile
        
        return profileScreen!
    }
    
    private func createLockController() -> LockViewController {
        let lockViewController: LockViewController? =
            Storyboard.main.instantiateViewController()
        return lockViewController!
    }
    
    private func setUp() {
        let item = BeaconItem(name: "com.example.myDeviceRegion",
                identifier: "D086020F-46DD-4482-B1E2-38EFD1B5DDC8",
                majorID: 100,
                minorID: 1)
        
        self.proximityMonitor = BeaconProximityMonitor(with: item)
        self.proximityMonitor.startMonitoring(for: .immediate,
        enteredHandler: {
            print("Entered immediate range!")
        },
        exitedHandler: {
            self.showLockClosed()
        })

        self.lockAPI = DefaultLockAPI(
                baseURL: "https://api.getkisi.com/",
                apiKey: "KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c")
        self.lockAPI.delegate = self

        self.scheduler = DefaultLockScheduler(
                with: self.proximityMonitor,
                lockAPI: self.lockAPI)
        self.scheduler.start(with: .seconds(4))
    }
    
    private func showLockClosed() {
        print("Closing the lock")
        self.lockViewController.lock()
    }
    
    private func showLockOpened() {
        print("Opening the lock")
        self.lockViewController.unlock()
    }
}

extension AppCoordinator: LockAPIDelegate {
    public func didLock(error: LockAPIError?) {
        self.showLockClosed()
    }
    
    public func didUnlock(error: LockAPIError?) {
        self.showLockOpened()
    }
}
