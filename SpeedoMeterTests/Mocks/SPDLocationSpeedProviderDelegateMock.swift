//
//  SPDLocationSpeedProviderDelegateMock.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import CoreLocation

@testable import SpeedoMeter

class SPDLocationSpeedProviderDelegateMock: SPDLocationSpeedProviderDelegate {
    var laseSpeed: CLLocationSpeed?
    
    func didUpdate(speed: CLLocationSpeed) {
        laseSpeed = speed 
    }
    
}
