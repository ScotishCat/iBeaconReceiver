import Foundation

public extension Bundle {
    /// Convenience function for loading a view or controller from xib file
    public func loadFromXib<T>(_ name: String, owner: Any?) -> T? {
        let nib = self.loadNibNamed(name, owner: owner, options: nil)
        let object = nib?.first as? T
        return object
    }
}
