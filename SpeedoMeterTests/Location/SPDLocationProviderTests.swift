//
//  SPDLocationProviderTests.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import XCTest
import CoreLocation
@testable import SpeedoMeter

class SPDLocationProviderTests: XCTestCase {

    var sut: SPDLocationProvider!
    var locationManagerMock: SPDLocationManagerMock!
    var locationAuthorizationMock: SPDLocationAuthorizationMock!
    var consumerMock: SPDLocationConsumerMock!
    override func setUp() {
        super.setUp()
        locationManagerMock = SPDLocationManagerMock()
        locationAuthorizationMock = SPDLocationAuthorizationMock()
        consumerMock = SPDLocationConsumerMock()
         
        sut = SPDDefaultLocationProvider(locationManager: locationManagerMock, locationAuthorization: locationAuthorizationMock)
        sut.add(consumerMock)
    }
    
    func test_setupNotfication_startUpdatingLocation() {
        // Arrange
        // Act
        NotificationCenter.default.post(name: .SPDLocationAuthorized, object: locationAuthorizationMock)
        // Assert
        XCTAssertTrue(locationManagerMock.didStartUpdatingLocation)
    }
    
    func test_updatedLocation_passLocationToConsumer() {
        // Arrange
        let expectedLocation = CLLocation()
        // Act
        locationManagerMock.delegate?.locationManager(locationManagerMock, didUpdateLocations: [expectedLocation])
        // Assert
        XCTAssertEqual(expectedLocation, consumerMock.lastLocation)
    }
    func test_updatedLocation_noPassedLocations_nothingIspassedToConsumer() {
        // Arrange
        // Act
        locationManagerMock.delegate?.locationManager(locationManagerMock, didUpdateLocations: [])
        // Assert
        XCTAssertNil(consumerMock.lastLocation)
    }
    func test_updatedLocation_severalLocations_mostRecentLocationIsPassedToConsumer() {
        // Arange
        let timestamp = Date()
        let oldLocation = createLocation(with: timestamp)
        let newLocation = createLocation(with: timestamp.addingTimeInterval(60))
        // Act
        locationManagerMock.delegate?.locationManager(locationManagerMock, didUpdateLocations: [oldLocation,newLocation])
        // Assert
        XCTAssertEqual(newLocation, consumerMock.lastLocation)
    }
    func test_dinit_stopUpdatingLocation() {
        // Arrange
        // Act
        sut = nil
        // Assert
        XCTAssertTrue(locationManagerMock.didStopUpdatingLocation)
        
    }
    
    private func  createLocation(with date: Date) -> CLLocation {
        let coordinate = CLLocationCoordinate2D()
        return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: date)
    }
}
