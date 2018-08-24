//
//  SPDLocationAuthorization.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/24/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import CoreLocation
import Swinject

extension NSNotification.Name {
    static let SPDLocationAuthorized = NSNotification.Name(rawValue: "NSNotification.Name.SPDLocationAuthorized")
}

protocol SPDLocationAuthorizationDelegate: class {
    func authorizationDenied(for locationAuthorization: SPDLocationAuthorization)
}

protocol SPDLocationAuthorization: class {
    var delegate: SPDLocationAuthorizationDelegate? { get set }
    func checkAuthorization()
}

class SPDDefaultLocationAuthorization {
    let locationManager: SPDLocationManager
    weak var delegate: SPDLocationAuthorizationDelegate?
    init(locationManager: SPDLocationManager) {
        self.locationManager = locationManager
        locationManager.authorizationDelegate = self
    }
}

extension SPDDefaultLocationAuthorization: SPDLocationAuthorization {
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

extension SPDDefaultLocationAuthorization: SPDLocationManagerAuthorizationDelegate {
    func locationManager(_ manager: SPDLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            NotificationCenter.default.post(name: .SPDLocationAuthorized, object: self)
        case .denied, .restricted:
            delegate?.authorizationDenied(for: self)
        default:
            break
        }
    }
}

class SPDLocationAuthorizationAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SPDLocationAuthorization.self, factory:  { r in
            let locationManager = r.resolve(SPDLocationManager.self)!
            return SPDDefaultLocationAuthorization(locationManager: locationManager)
        }).inObjectScope(.weak)
    }
}
