//
//  File.swift
//  
//
//  Created by Mac on 29.09.2020.
//

import UIKit
import AC_iOS_AR
import CoreLocation.CLLocation

open class ARHelper {
    
    public static var serverAddress: String = ""
    
    //MARK: Localization
    public class func getDataForLocalization(completion: @escaping (_ imageData: Data?, _ location: CLLocation?, _ photoInfo: [String:Any]?, _ pose: Pose?) -> Void) {
        AR.Localization.getData(completion: completion)
    }

    //MARK: Session
    public class func startAR() {
        AR.Session.startAR()
    }
    
    public class func stopAR() {
        AR.Session.stopAR()
    }
    
    public class func show(localizationResult: SDK.Localization.localizationResultSwagger) {
        guard let data = try? JSONEncoder().encode(localizationResult) else { return }
        AR.Session.show(localizationData: data)
    }
    
    public class func set(server address: String, arView backView: UIView) {
        ARHelper.serverAddress = address
        AR.Session.set(arView: backView)
    }

}
