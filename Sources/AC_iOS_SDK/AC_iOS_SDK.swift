import Foundation
import CoreLocation
import AC_iOS_NET
import UIKit
import AC_iOS_AR

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

        public typealias localizeMPDResponse = NET.Localizer.localizeMPDResponse
        public static func localizeMultipartData(at serverAddress: String = Servers.addresses[2], imageData: Data, location: CLLocation, completion: @escaping NET.Localizer.localizeMPDCompletionHandler) {
            let encoder = JSONEncoder()
            let json = LocalizationModel.LocalizeJSONSettings(location: location)
            guard let jsonData = try? encoder.encode(json) else { completion(nil, nil, nil); return }
            
            print( String(data: jsonData, encoding: .utf8)! )
            
            let request = LocalizationModel.Localize.Request(imageData: [imageData], jsonData: jsonData)
            NET.Localizer.localizeMPD(at: serverAddress, for: request, completion: completion)
        }
        
        public typealias localizationResultSwagger = NET.Localizer.localizationResultSwagger
        public static func localizeSwagger(server address: String = Servers.addresses[0], for image: Data, location: CLLocation, photoInfo: [String:Any] = [:], completion: @escaping ((_ data: localizationResultSwagger?,_ error: Error?) -> Void)) {
            //TODO: add our server address
            //make URL for image
            guard let imageURL = FileUtils.writeFile(name: "iosImageForLocalization", data: image) else {
                completion(nil, NSError(domain: "ac.ios.sdk.error", code: 1, userInfo: ["error": "no image url"]))
                return
            }
            //make imageDescription
            
            let rotationIndex: Int? = photoInfo["rotation"] as? Int
            let rotation: AC_iOS_NET.ImageDescription.Rotation? = rotationIndex == nil ? nil : AC_iOS_NET.ImageDescription.Rotation(rawValue: rotationIndex!)

            let imageDescriptionGps: AC_iOS_NET.ImageDescriptionGps = AC_iOS_NET.ImageDescriptionGps(
                latitude: Float(location.coordinate.latitude),
                longitude: Float(location.coordinate.longitude),
                altitude: Float(location.altitude),
                hdop: Float(location.horizontalAccuracy)
            )
            
            let cameraIntrinsics: AC_iOS_NET.CameraIntrinsics = AC_iOS_NET.CameraIntrinsics(
                fx: photoInfo["fx"] as? Float ?? .zero,
                fy: photoInfo["fy"] as? Float ?? .zero,
                cx: photoInfo["cx"] as? Float ?? .zero,
                cy: photoInfo["cy"] as? Float ?? .zero
            )
            
            let imageDescription = NET.Localizer.imageDescription(
                gps: imageDescriptionGps,
                intrinsics: cameraIntrinsics,
                focalLengthIn35mmFilm: photoInfo["focalLengthIn35mmFilm"] as? Int, //Int?
                mirrored: photoInfo["mirrored"] as? Bool, //Bool?
                rotation: rotation //ImageDescription.Rotation?
            )
            
            NET.Localizer.localizeSwagger(server: address, for: imageURL, with: imageDescription) { (localizationSwaggerResult, error) in
                completion(localizationSwaggerResult, error)
            }
        }

    }
    
    open class Objects {
        
        //MARK: Local API
        public typealias addObjectModel = NET.ObjectOperator.addObjectModel
        public typealias addObjectResponse = NET.ObjectOperator.addObjectResponse
        public typealias stickerField = NET.ObjectOperator.stickerField
        public static func addObject(to serverAddress: String = Servers.addresses[2], imageData: Data, objectModel: addObjectModel, completion: @escaping NET.ObjectOperator.addObjectMPDCompletionHandler) {
            let encoder = JSONEncoder()
            guard let jsonData = try? encoder.encode(objectModel) else { completion(nil, nil, nil); return }
            
            print(String(data: jsonData, encoding: .utf8)!)
            
            let request = ObjectModel.AddObject.Request(imageData: imageData, jsonData: jsonData)
            NET.ObjectOperator.addObjectMPD(to: serverAddress, for: request, completion: completion)
        }
        
        public typealias deleteObjectResponse = NET.ObjectOperator.deleteObjectResponse
        public static func deleteObject(from serverAddress: String = Servers.addresses[2], stickerID: Int, completion: @escaping NET.ObjectOperator.deleteObjectCompletionHandler) {
            let request = ObjectModel.DeleteObject.Request(stickerID: stickerID)
            NET.ObjectOperator.deleteObject(from: serverAddress, by: request, completion: completion)
        }

        //MARK: Open API
        public typealias objectWithPose = AC_iOS_NET.ObjectWithPose
        public static func addObjectWithPose(server address: String = Servers.addresses[0], objectWithPose: SDK.Objects.objectWithPose, apiResponseQueue: DispatchQueue = .main, completion: @escaping NET.ObjectOperator.addObjectWithPoseCompletionHandler ) {
            NET.ObjectOperator.addObjectWithPose(server: address, objectWithPose: objectWithPose, apiResponseQueue: apiResponseQueue, completion: completion)
        }
        
        
        public typealias addObjectByImageCompletionHandler = NET.ObjectOperator.addObjectWithPoseCompletionHandler
        public static func addObjectByImage(server address: String = Servers.addresses[0], image: Data, description: NET.ObjectOperator.objectWithMarkedImage, apiResponseQueue: DispatchQueue = .main, location: CLLocation, completion: @escaping addObjectByImageCompletionHandler) {
            
            guard let imageURL = FileUtils.writeFile(name: "iosImageForLocalization", data: image) else {
                completion(nil, NSError(domain: "ac.ios.sdk.error", code: 1, userInfo: ["error": "no image url"]))
                return
            }
            
            NET.ObjectOperator.addObjectByImage(server: address, description: description, image: imageURL, apiResponseQueue: apiResponseQueue, completion: completion)
        }
        
    }
    
    open class ARScene {
        
        public typealias cameraPose = AC_iOS_AR.Pose
        public static func getLocalizationResult(location: CLLocation? = nil, completion: @escaping (Data?, SDK.Localization.localizationResultSwagger?, Error?, cameraPose?) -> Void) {
            ARHelper.getDataForLocalization { (mImageData, mLocation, mPhotoInfo, mPose) in
                guard let imageData = mImageData, let currentLocation = mLocation ?? location, let photoInfo = mPhotoInfo, let pose = mPose else { completion(nil, nil, nil, nil); return }
                SDK.Localization.localizeSwagger(server: ARHelper.serverAddress, for: imageData, location: currentLocation, photoInfo: photoInfo) { (mLocalizationResult, mError) in
                    completion(imageData, mLocalizationResult, mError, pose)
                }
            }
        }

        public static func setup(server address: String = Servers.addresses[0], arView backView: UIView, stickerDelegate: StickerDelegate? = nil) {
            ARHelper.set(server: address, arView: backView, stickerDelegate: stickerDelegate)
        }
        
        public static func start() {
            ARHelper.startAR()
        }
        
        public static func show(location: CLLocation? = nil, completion: @escaping (Bool, Error?) -> Void) {
            SDK.ARScene.getLocalizationResult(location: location) { (_, mLocalizationResult, error, _) in
                guard error == nil else { completion(false, error); return }
                guard let localizationResult = mLocalizationResult else { completion(false, nil); return }
                ARHelper.show(localizationResult: localizationResult)
                completion(true, nil)
            }
        }

        public static func stop() {
            ARHelper.stopAR()
        }
        
        public static func takePhoto(completion: @escaping (Data?, NSError?, UIDeviceOrientation?) -> Void) {
            ARHelper.takePhoto(completion: completion)
        }
        
        public static func delete(by stickerID: Int) {
            ARHelper.delete(by: stickerID)
        }

    }
    
}
