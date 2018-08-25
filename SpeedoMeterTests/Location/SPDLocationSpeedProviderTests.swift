//
//  SPDLocationSpeedProviderTests.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import XCTest
import CoreLocation

@testable import SpeedoMeter

class SPDLocationSpeedProviderTests: XCTestCase {
    var sut: SPDLocationSpeedProvider!
    var locationProviderMoc: SPDLocationProviderMock!
    var delegateMock: SPDLocationSpeedProviderDelegateMock!
    
    override func setUp() {
        super.setUp()
        locationProviderMoc = SPDLocationProviderMock()
        delegateMock = SPDLocationSpeedProviderDelegateMock()
        
        sut = SPDDefaultLocationSpeedProvider(locationProvider: locationProviderMoc)
        sut.delegate = delegateMock
    }
    
    func test_consumeLocation_speedLessThanZero_provideZeroToDelegate() {
        // Arrange
        let location = createLocation(with: -10)
        // Act
        locationProviderMoc.lastConsumer?.consumeLocation(location)
        // Assert
        XCTAssertEqual(0, delegateMock.laseSpeed)
    }
    func test_consumeLocation_speedGreateThanZero_provideSpeedToDelegate() {
        // Arrange
        let location = createLocation(with: 10)
        // Act
        locationProviderMoc.lastConsumer?.consumeLocation(location)
        // Assert
        XCTAssertEqual(10, delegateMock.laseSpeed)
    }
    
    private func createLocation(with speed: CLLocationSpeed) -> CLLocation {
        let coordinate = CLLocationCoordinate2D()
        
        return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: speed, timestamp: Date())
    }
}
