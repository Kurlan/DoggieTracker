//
//  DoggieTrackerTests.swift
//  DoggieTrackerTests
//
//  Created by STEVE HUYNH on 10/6/15.
//  Copyright © 2015 SLH. All rights reserved.
//

import UIKit
import XCTest
@testable import DoggieTracker

class DoggieTrackerTests: XCTestCase {
    
    // MARK: FoodTracker Tests
    func testMealInitialization() {
        // Success case.
        let potentialItem = Dog(name: "Newest dog", photo: nil, rating: 5)
        XCTAssertNotNil(potentialItem)
        
        // Failure cases.
        let noName = Dog(name: "", photo: nil, rating: 0)
        XCTAssertNil(noName, "Empty name is invalid")
        
        let badRating = Dog(name: "Really bad rating", photo: nil, rating: -1)
        XCTAssertNil(badRating, "Negative ratings are invalid, be positive")
    }
}