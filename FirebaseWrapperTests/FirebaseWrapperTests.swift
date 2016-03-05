//
//  FirebaseWrapperTests.swift
//  FirebaseWrapperTests
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import XCTest
@testable import FirebaseWrapper

class FirebaseWrapperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     success test for /users
     */
    func testUsersSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUsers({ (json) -> Void in
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    /**
     fail test for /users/<uid> - validation
     */
    func testUserInfoFailedValidation() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserInfo("", success: { (json) -> Void in
            expectation?.fulfill()
            XCTFail("Must fail")
            }, failure: { (error) -> Void in
                expectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    /**
     fail test for /users/<uid> - bad UID
     */
    func testUserInfoFailed() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserInfo("asdf-1234", success: { (json) -> Void in
            expectation?.fulfill()
            XCTAssert(json.type == .Null, "Must be null")
            }, failure: { (error) -> Void in
                expectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    /**
     success test for /users/<uid>
     */
    func testUserInfoSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserInfo(Configuration.testUID, success: { (json) -> Void in
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    /**
     fail test for /trips/<uid> - validation
     */
    func testUserTripsFailedValidation() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrips("", success: { (json) -> Void in
            expectation?.fulfill()
            XCTFail("Must fail")
            }, failure: { (error) -> Void in
                expectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    /**
     fail test for /trips/<uid> - bad UID
     */
    func testUserTripsFailed() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrips("asdf-1234", success: { (json) -> Void in
            expectation?.fulfill()
            XCTAssert(json.type == .Null, "Must be null")
            }, failure: { (error) -> Void in
                expectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    /**
     success test for /trips/<uid>
     */
    func testUserTripsSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrips(Configuration.testUID, success: { (json) -> Void in
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
}
