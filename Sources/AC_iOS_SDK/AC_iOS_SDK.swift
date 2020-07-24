import Foundation
import CoreLocation

struct AC_iOS_SDK {
    var text = "Hello, World!"
    var version = "1.0.1"
}

class AugmentedCity {
    
    class Common {
        static func info() {
            let sdk = AC_iOS_SDK()
            
            print("AC_iOS_SDK, text = \(sdk.text), version = \(sdk.version)")
        }
    }
    
    class Localization {
        static func checkNearPlaceholders() {
            print("checkNearPlaceholders")
        }

        static func checkNearCity() {
            print("checkNearCity")
        }
    }
    
    class Objects {
        
        static func addObject(type: String) {
            print("Added object: \(type)")
        }
        
    }
    
}
