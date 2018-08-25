//
//  SPDLocationSpeedCheckerTests.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import XCTest
import CoreLocation

@testable import SpeedoMeter

class SPDLocationSpeedCheckerTests: XCTestCase {
    
    var sut: SPDLocationSpeedChecker!
    var locationProviderMock: SPDLocationProviderMock!
    var delegateMock: SPDLocationSpeedCheckerDelegateMock!
    override func setUp() {
        super.setUp()
        locationProviderMock = SPDLocationProviderMock()
        delegateMock = SPDLocationSpeedCheckerDelegateMock()
        
        sut = SPDDefaultLocationSpeedChecker(locationProvider: locationProviderMock)
        sut.delegate = delegateMock
    }
    
    func test_isExceededMaximumSpeed_maximumSpeedIsNil_false() {
        // Arrange
        sut.maximumSpeed = nil
        let location = createLocation(with: 1000)
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        // Assert
        XCTAssertFalse(sut.isExceededMaximumSpeed)
    }
    func test_isExceededMaximumSpeed_maximumSpeedNotExeceded_false() {
        // Arrange
        sut.maximumSpeed = 100
        let location = createLocation(with: 90)
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        // Assert
        XCTAssertFalse(sut.isExceededMaximumSpeed)
    }
    func test_isExceededMaximumSpeed_maximumSpeedExceeded_true() {
        // Arrange
        sut.maximumSpeed = 100
        let location = createLocation(with: 110)
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        // Assert
        XCTAssertTrue(sut.isExceededMaximumSpeed)
    }
    func test_isExceededMaximumSpeed_maximumSpeedExceeded_delegateIsinformed() {
        // Arrange
        sut.maximumSpeed = 100
        let location = createLocation(with: 110)
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(location)
        // Assert
        XCTAssertTrue(delegateMock.didchangeExeedingMaxSpeed)
    }
    func test_isExceededMaximumSpeed_maximumSpeedSetToExceededValue_true() {
        // Arrange
        let location = createLocation(with: 110)
        locationProviderMock.lastConsumer?.consumeLocation(location)
        // Act
        sut.maximumSpeed = 100
        // Assert
        XCTAssertTrue(sut.isExceededMaximumSpeed)
    }
    func test_isExceededMaximumSpeed_maximumSpeedSetToExceededValue_delegateIsinformed() {
        // Arrange
        let location = createLocation(with: 110)
        locationProviderMock.lastConsumer?.consumeLocation(location)
        // Act
        sut.maximumSpeed = 100
        // Assert
        XCTAssertTrue(delegateMock.didchangeExeedingMaxSpeed)
    }
    func test_isExceededMaximumSpeed_propertyDoseNotChange_delegateIsNotinformed() {
        // Arrange
        sut.maximumSpeed = 100
        let firstLocation = createLocation(with: 110)
        let secondLocation = createLocation(with: 115)
        locationProviderMock.lastConsumer?.consumeLocation(firstLocation)
        delegateMock.didchangeExeedingMaxSpeed = false
        // Act
        locationProviderMock.lastConsumer?.consumeLocation(secondLocation)
        // Assert
        XCTAssertFalse(delegateMock.didchangeExeedingMaxSpeed)
    }
    
    private func createLocation(with speed:CLLocationSpeed) -> CLLocation {
        let coordinate = CLLocationCoordinate2D()
        return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, course: 0, speed: speed, timestamp: Date())
    }
}
