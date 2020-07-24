import Foundation
import CoreLocation

struct AC_iOS_SDK {
    var text = "Hello, World!"
    var version = "1.0.1"
}

open class SDK {
    
    open class Common {
        open static func info() {
            let sdk = AC_iOS_SDK()
            
            print("AC_iOS_SDK, text = \(sdk.text), version = \(sdk.version)")
        }
    }
    
    open class Localization {
        open static func checkNearPlaceholders() {
            print("checkNearPlaceholders")
        }

        static func checkNearCity() {
            print("checkNearCity")
        }
    }
    
    open class Objects {
        
        open static func addObject(type: String) {
            print("Added object: \(type)")
        }
        
    }
    
}
