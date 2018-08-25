//
//  SPDLocationManagerMock.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import Foundation
import CoreLocation

@testable import SpeedoMeter

class SPDLocationManagerMock: SPDLocationManager {
    weak var delegate: SPDLocationManagerDelegate?
    weak var authorizationDelegate: SPDLocationManagerAuthorizationDelegate?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
   
    var requestedWhenInUseAuthorization = false
    var didStartUpdatingLocation = false
    var didStopUpdatingLocation = false
    
    func requestWhenInUseAuthorization() {
        requestedWhenInUseAuthorization = true
    }
    
    func startUpdatingLocation() {
        didStartUpdatingLocation = true
    }
    
    func stopUpdatingLocation() {
        didStopUpdatingLocation = true
    }
}
