//
//  ARCameraView.swift
//  AC_demo
//
//  Created by Mac on 01.10.2020.
//

import AC_iOS_SDK
import SwiftUI

enum ARCameraState {
    case startAR
    case normal
}

struct ARCameraView: UIViewControllerRepresentable {
    
    private let vc = UIViewController()

    @Binding var arCameraState: ARCameraState
    
    func makeUIViewController(context: Context) -> UIViewController {

        SDK.ARScene.setup(arView: vc.view)
        SDK.ARScene.start()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
        switch arCameraState {
        case .startAR:
            SDK.ARScene.show(location: LocationManager.shared.latestLocation) { (isOK, error) in
                print(isOK)
                guard error == nil else { print(error!); return }
            }
            
        case .normal:
            break
        }
        
        DispatchQueue.main.async {
            self.arCameraState = .normal
        }
        
    }

}
