//
//  SPDLocationSpeedCheckerDelegateMock.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import Foundation


@testable import SpeedoMeter

class SPDLocationSpeedCheckerDelegateMock: SPDLocationSpeedCheckerDelegate {
    var didchangeExeedingMaxSpeed = false
    func exeedingMaximumSpeedChange(for speedChecker: SPDLocationSpeedChecker) {
        didchangeExeedingMaxSpeed = true
    }
}
