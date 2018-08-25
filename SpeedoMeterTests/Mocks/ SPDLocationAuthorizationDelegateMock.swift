//
//   SPDLocationAuthorizationDelegateMock.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import Foundation

@testable import SpeedoMeter

class SPDLocationAuthorizationDelegateMock: SPDLocationAuthorizationDelegate {
    var authorizationWasDenied = false
    func authorizationDenied(for locationAuthorization: SPDLocationAuthorization) {
        authorizationWasDenied = true
    }
    
}
