import Foundation

public enum LockAPIError: Error {
    case connectionFailure
}

public protocol LockAPIDelegate: class {
    func didLock(error: LockAPIError?)
    func didUnlock(error: LockAPIError?)
}
    
public protocol LockAPI: class {
    weak var delegate: LockAPIDelegate? { get set }

    func lock()
    func unlock()
}

public class DefaultLockAPI: LockAPI {

    public weak var delegate: LockAPIDelegate?
    
    public private(set) var baseURL: URL

    private let APIKey: String//"KISI-LINK 75388d1d1ff0dff6b7b04a7d5162cc6c"
    private let session: URLSession // TODO: Replace with custom protocol if needed
    
    public init?(
            baseURL: String,
            apiKey: String,
            session: URLSession = URLSession.shared) {
        
        guard let url = URL(string: baseURL) else {
            return nil
        }
        
        self.baseURL = url
        self.APIKey = apiKey
        self.session = session
    }

    public func lock() {
        // TODO: Implement
    }
    
    public func unlock() {
        let url = self.baseURL.appendingPathComponent("locks/5873/access")
        var request = URLRequest(url: url.absoluteURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields?["Authorization"] = self.APIKey
        self.delegate?.didUnlock(error: nil)

        self.session.dataTask(with: request) {
            (data, response, error) in
            // TODO: Check response for HTTP codes etc.
            if error != nil {
                self.delegate?.didUnlock(error: .connectionFailure)
                return
            }
//            self.delegate?.didUnlock(error: nil)
            
        }.resume()
    }
}
