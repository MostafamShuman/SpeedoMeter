//
//  SPDLocationSpeedChecker.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/24/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import CoreLocation
import Swinject

protocol SPDLocationSpeedCheckerDelegate: class {
    func exeedingMaximumSpeedChange(for speedChecker:SPDLocationSpeedChecker)
}
protocol SPDLocationSpeedChecker: class {
    var delegate: SPDLocationSpeedCheckerDelegate? { get set }
    var maximumSpeed: CLLocationSpeed? { get set }
    var isExceededMaximumSpeed: Bool { get }
}

class SPDDefaultLocationSpeedChecker {
    let locationProvider: SPDLocationProvider
    weak var delegate: SPDLocationSpeedCheckerDelegate?
    var maximumSpeed: CLLocationSpeed? {
        didSet {
            checkIfSpeedExeeded()
        }
    }
    var isExceededMaximumSpeed: Bool = false {
        didSet {
            if oldValue != isExceededMaximumSpeed {
                delegate?.exeedingMaximumSpeedChange(for: self)
            }
        }
    }
    var lastLocation: CLLocation? {
        didSet {
            checkIfSpeedExeeded()
        }
    }
    init(locationProvider: SPDLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}
private extension SPDDefaultLocationSpeedChecker {
    func checkIfSpeedExeeded(){
        if let maximumSpeed = maximumSpeed, let location = lastLocation{
            isExceededMaximumSpeed = location.speed > maximumSpeed
        } else {
            isExceededMaximumSpeed = false
        }
    }
}
extension SPDDefaultLocationSpeedChecker: SPDLocationSpeedChecker {
    
}

extension SPDDefaultLocationSpeedChecker: SPDLocationConsumer {
    func consumeLocation(_ location: CLLocation) {
        lastLocation = location
    }
}

class SPDLocationSpeedCheckerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SPDLocationSpeedChecker.self, factory: { r in
            let locationProvider = r.resolve(SPDLocationProvider.self)!
            return SPDDefaultLocationSpeedChecker(locationProvider: locationProvider)
        }).inObjectScope(.weak)
    }
}
