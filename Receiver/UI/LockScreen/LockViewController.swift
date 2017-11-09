import UIKit

class LockViewController: UIViewController {
    @IBOutlet weak var lockView: AnimatedLockView!
    
    public func unlock() {
        self.lockView.unlock()
    }

    public func lock() {
        self.lockView.lock()
    }
}
