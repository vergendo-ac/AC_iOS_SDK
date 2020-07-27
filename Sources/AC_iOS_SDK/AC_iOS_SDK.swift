import Foundation
import CoreLocation
import AC_iOS_NET

struct AC_iOS_SDK {
    var text = "Hello, World!"
    var version = "1.0.1"
}

open class SDK {
    
    open class Common {
        public static func info() {
            let sdk = AC_iOS_SDK()
            print("AC_iOS_SDK, text = \(sdk.text), version = \(sdk.version)")
        }
    }
    
    open class Localization {
        public static func prepare(location: CLLocation, completion: ((String) -> Void)? = nil) {
            let request = LocalizationModel.Prepare.Request(location: location)
            NET.Localizer.prepare(for: request) { (prepareResponse, urlResponse, error) in
                guard error == nil else { completion?(error!.localizedDescription); return }
                guard let response = prepareResponse else { completion?("No response"); return }
                completion?(response.status.message)
            }
        }
        
        public static func localize(imageData: Data, completion: @escaping NET.Localizer.localizeCompletionHandler) {
            let request = LocalizationModel.Localize.Request(imageData: imageData)
            NET.Localizer.localize(at: Servers.addresses[0], for: request, completion: completion)
        }
    }
    
    open class Objects {
        
        public static func addObject(type: String) {
            print("Added object: \(type)")
        }
        
    }
    
}
