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
        public static func prepare(at serverAddress: String =  Servers.addresses[2], location: CLLocation, completion: ((String) -> Void)? = nil) {
            let request = LocalizationModel.Prepare.Request(location: location)
            NET.Localizer.prepare(at: serverAddress, for: request) { (prepareResponse, urlResponse, error) in
                guard error == nil else { completion?(error!.localizedDescription); return }
                guard let response = prepareResponse else { completion?("No response"); return }
                completion?(response.status.message ?? "No message")
            }
        }
        
        public static func localize(at serverAddress: String = Servers.addresses[2], imageData: Data, completion: @escaping NET.Localizer.localizeCompletionHandler) {
            let request = LocalizationModel.Localize.Request(imageData: [imageData])
            NET.Localizer.localize(at: serverAddress, for: request, completion: completion)
        }

        public static func localizeMultipartData(at serverAddress: String = Servers.addresses[2], imageData: Data, location: CLLocation, completion: @escaping NET.Localizer.localizeMPDCompletionHandler) {
            let encoder = JSONEncoder()
            let json = LocalizationModel.LocalizeJSONSettings(location: location)
            guard let jsonData = try? encoder.encode(json) else { completion(nil, nil, nil); return }
            
            let request = LocalizationModel.Localize.Request(imageData: [imageData], jsonData: jsonData)
            NET.Localizer.localizeMPD(at: serverAddress, for: request, completion: completion)
        }

    }
    
    open class Objects {
        
        public typealias addObjectModel = NET.ObjectOperator.addObjectModel
        public typealias stickerField = NET.ObjectOperator.stickerField
        public static func addObject(to serverAddress: String = Servers.addresses[2], imageData: Data, objectModel: addObjectModel, completion: @escaping NET.ObjectOperator.addObjectMPDCompletionHandler) {
            let encoder = JSONEncoder()
            guard let jsonData = try? encoder.encode(objectModel) else { completion(nil, nil, nil); return }
            
            let request = ObjectModel.AddObject.Request(imageData: imageData, jsonData: jsonData)
            NET.ObjectOperator.addObjectMPD(to: serverAddress, for: request, completion: completion)
        }
        
    }
    
}
