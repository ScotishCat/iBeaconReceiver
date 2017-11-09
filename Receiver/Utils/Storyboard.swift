import UIKit

enum Storyboard: String {
    case main = "Main"
    
    private func getStoryboard() -> UIStoryboard {
        let rawValue = self.rawValue
        return UIStoryboard(name: rawValue, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>() -> T? {
        let storyboard = self.getStoryboard()
        let identifier = String(describing: T.self)
        return storyboard.instantiateViewController(withIdentifier: identifier) as? T
    }

    func instantiateInitialViewController() -> UIViewController? {
        return self.getStoryboard().instantiateInitialViewController()
    }
}
