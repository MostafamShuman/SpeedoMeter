//
//  SPDLocationProviderMock.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import Foundation


@testable import SpeedoMeter


class SPDLocationProviderMock: SPDLocationProvider {
    var lastConsumer: SPDLocationConsumer?
    func add(_ consumer: SPDLocationConsumer) {
        lastConsumer = consumer
    }
}
