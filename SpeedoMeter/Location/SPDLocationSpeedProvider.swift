//
//  SPDLocationSpeedProvider.swift
//  SpeedoMeter
//
//  Created by Mostafa Shuman on 8/24/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import CoreLocation
import Swinject
protocol SPDLocationSpeedProviderDelegate: class {
    func didUpdate(speed: CLLocationSpeed)
}
protocol SPDLocationSpeedProvider: class {
    var delegate: SPDLocationSpeedProviderDelegate? { get set }
}
class SPDDefaultLocationSpeedProvider {
    let locationProvider: SPDLocationProvider
    weak var delegate: SPDLocationSpeedProviderDelegate?
    init(locationProvider: SPDLocationProvider) {
        self.locationProvider = locationProvider
        locationProvider.add(self)
    }
}
extension SPDDefaultLocationSpeedProvider: SPDLocationSpeedProvider {
    
}
extension SPDDefaultLocationSpeedProvider: SPDLocationConsumer {
    func consumeLocation(_ location: CLLocation) {
        let speed = max(location.speed, 0)
        delegate?.didUpdate(speed: speed)
    }
    
}

class SPDLocationSpeedProviderAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SPDLocationSpeedProvider.self,factory: { r in
            let locationProvider = r.resolve(SPDLocationProvider.self)!
            return SPDDefaultLocationSpeedProvider(locationProvider: locationProvider)
        }).inObjectScope(.weak)
    }
}
