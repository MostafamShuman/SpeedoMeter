//
//  SPDLocationConsumerMock.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import Foundation
import CoreLocation

@testable import SpeedoMeter

class SPDLocationConsumerMock: SPDLocationConsumer {
    var lastLocation: CLLocation?
    func consumeLocation(_ location: CLLocation) {
        lastLocation = location
    }
}
