import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var appCoodrinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.appCoodrinator = AppCoordinator(
            with: self.window!,
            launchOptions: launchOptions)
        self.appCoodrinator.start()
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.appCoodrinator.applicationWillEnterForeground()
    }
    
}

