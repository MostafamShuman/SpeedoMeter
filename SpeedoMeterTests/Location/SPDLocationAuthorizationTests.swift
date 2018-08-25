//
//  SPDLocationAuthorizationTests.swift
//  SpeedoMeterTests
//
//  Created by Mostafa Shuman on 8/25/18.
//  Copyright © 2018 Mostafa Shuman. All rights reserved.
//

import XCTest

@testable import SpeedoMeter
class SPDLocationAuthorizationTests: XCTestCase {
    
    var sut: SPDLocationAuthorization!
    var locationManagerMock: SPDLocationManagerMock!
    var delegateMock: SPDLocationAuthorizationDelegateMock!
    
    
    override func setUp() {
        super.setUp()
        locationManagerMock = SPDLocationManagerMock()
        delegateMock = SPDLocationAuthorizationDelegateMock()
        
        sut = SPDDefaultLocationAuthorization(locationManager: locationManagerMock)
        sut.delegate = delegateMock
    }
    
    func test_checkAuthorization_notDetermined_requestAuthorization() {
        // Arrange
        locationManagerMock.authorizationStatus = .notDetermined
        // Act
        sut.checkAuthorization()
        // Assert
        XCTAssertTrue(locationManagerMock.requestedWhenInUseAuthorization)
    }
    func test_checkAuthorization_determined_doesNotRequestAuthorization() {
        // Arange
        locationManagerMock.authorizationStatus = .denied
        // Act
        sut.checkAuthorization()
        // Assert
        XCTAssertFalse(locationManagerMock.requestedWhenInUseAuthorization)
    }
    func test_didChangeAuthorizationStatus_authorizedWhenInUse_notficationIsPosted(){
        // Arrange
        let notficationName = NSNotification.Name.SPDLocationAuthorized.rawValue
        let _ = expectation(forNotification: NSNotification.Name(rawValue: notficationName)
            , object: sut, handler: nil)
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .authorizedWhenInUse)
        // Assert
        waitForExpectations(timeout: 0, handler: nil)
    }
    func test_didChangeAuthorizationStatus_authorizedAlways_notficationIsPosted(){
        // Arrange
        let notficationName = NSNotification.Name.SPDLocationAuthorized.rawValue
        let _ = expectation(forNotification: NSNotification.Name(rawValue: notficationName)
            , object: sut, handler: nil)
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .authorizedAlways)
        // Assert
        waitForExpectations(timeout: 0, handler: nil)
    }
    func test_didChangeAuthorizationStatus_denied_delegateInformed(){
        // Arrange
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .denied)
        // Assert
        XCTAssertTrue(delegateMock.authorizationWasDenied)
        
    }
    func test_didChangeAuthorizationStatus_restricted_delegateInformed(){
        // Arrange
        // Act
        locationManagerMock.authorizationDelegate?.locationManager(locationManagerMock, didChangeAuthorization: .restricted)
        // Assert
        XCTAssertTrue(delegateMock.authorizationWasDenied)
    }
}
