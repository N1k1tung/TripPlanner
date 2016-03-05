//
//  FirebaseWrapperTests.swift
//  FirebaseWrapperTests
//
//  Created by Nikita Rodin on 3/5/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import XCTest
import CoreLocation
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
    
    // MARK: - users
    // MARK: - read
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
    
    // MARK: update
    
    /**
     fail test for /users/<uid> - validation uid
     */
    func testUpdateUserInfoFailedValidation1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.name = "Name"
        user.email = "email@asdf.dd"
        FirebaseRequestManager.sharedInstance().updateUserInfo("", data: user, success: { (json) -> Void in
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
     fail test for /users/<uid> - validation user name
     */
    func testUpdateUserInfoFailedValidation2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.email = "email@asdf.dd"
        FirebaseRequestManager.sharedInstance().updateUserInfo("1234", data: user, success: { (json) -> Void in
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
     fail test for /users/<uid> - validation user email
     */
    func testUpdateUserInfoFailedValidation3() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.name = "Name"
        FirebaseRequestManager.sharedInstance().updateUserInfo("1234", data: user, success: { (json) -> Void in
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
     success test for /users/<uid>
     */
    func testUpdateUserInfoSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.name = "Name"
        user.email = "email@asdf.dd"

        FirebaseRequestManager.sharedInstance().updateUserInfo(Configuration.testUID, data: user, success: { (json) -> Void in
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    // MARK: create
    
    /**
     fail test for /users/<uid> - validation user name
     */
    func testCreateUserInfoFailedValidation1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.email = "email@asdf.dd"
        FirebaseRequestManager.sharedInstance().createUserInfo(user, success: { (json) -> Void in
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
     fail test for /users/<uid> - validation user email
     */
    func testCreateUserInfoFailedValidation2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.name = "Name"
        FirebaseRequestManager.sharedInstance().createUserInfo(user, success: { (json) -> Void in
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
     success test for create-delete /users/<uid>
     */
    func testCreateAndDeleteUserInfoSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let user = User()
        user.name = "Name"
        user.email = "email@asdf.dd"
        
        FirebaseRequestManager.sharedInstance().createUserInfo(user, success: { (json) -> Void in
            FirebaseRequestManager.sharedInstance().deleteUserInfo(json["name"].stringValue, success: { (json) -> Void in
                expectation?.fulfill()
                }, failure: { (error) -> Void in
                    expectation?.fulfill()
                    XCTFail("Must succeed")
            })
            
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    // MARK: delete
    
    /**
    fail test for /users/<uid> - validation uid
    */
    func testDeleteUserInfoFailedValidation() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().deleteUserInfo("", success: { (json) -> Void in
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
    func testDeleteUserInfoFailed() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().deleteUserInfo("asdf-1234", success: { (json) -> Void in
            expectation?.fulfill()
            XCTAssert(json.type == .Null, "Must be null")
            }, failure: { (error) -> Void in
                expectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    
    // MARK: - trips
    
    // MARK: read
    
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
    
    /**
     fail test for /trips/<uid>/<tripID> - validation uid
     */
    func testUserTripFailedValidation1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrip("", withID: "1234", success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - validation tripID
     */
    func testUserTripFailedValidation2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrip("1234", withID: "", success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - bad UID
     */
    func testUserTripFailed1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrip("asdf-1234", withID: Configuration.testTripID, success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - bad tripID
     */
    func testUserTripFailed2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrip(Configuration.testUID, withID: "asdf-1234", success: { (json) -> Void in
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
     success test for /trips/<uid>/<tripID>
     */
    func testUserTripSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().getUserTrip(Configuration.testUID, withID: Configuration.testTripID, success: { (json) -> Void in
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }

    
    // MARK: update
    
    /**
    fail test for /trips/<uid>/<tripID> - validation uid
    */
    func testUpdateUserTripFailedValidation1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))

        FirebaseRequestManager.sharedInstance().updateUserTrip("", withID: "1234", data: trip, success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - validation tripID
     */
    func testUpdateUserTripFailedValidation2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))

        FirebaseRequestManager.sharedInstance().updateUserTrip("1234", withID: "", data: trip, success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - validation trip destination
     */
    func testUpdateUserTripFailedValidation3() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        
        FirebaseRequestManager.sharedInstance().updateUserTrip("1234", withID: "1234", data: trip, success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - validation trip dates
     */
    func testUpdateUserTripFailedValidation4() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))
        trip.startDate = trip.endDate.dateByAddingTimeInterval(1234)

        FirebaseRequestManager.sharedInstance().updateUserTrip("1234", withID: "1234", data: trip, success: { (json) -> Void in
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
     success test for /trips/<uid>/<tripID>
     */
    func testUpdateUserTripSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))
        trip.comment = "Success!"
        
        FirebaseRequestManager.sharedInstance().updateUserTrip(Configuration.testUID, withID: Configuration.testTripID, data: trip, success: { (json) -> Void in
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    // MARK: create
    
    /**
    fail test for /trips/<uid>/<tripID> - validation uid
    */
    func testCreateUserTripFailedValidation1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))
        
        FirebaseRequestManager.sharedInstance().createUserTrip("", data: trip, success: { (json) -> Void in
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
    fail test for /trips/<uid>/<tripID> - validation trip destination
    */
    func testCreateUserTripFailedValidation2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        
        FirebaseRequestManager.sharedInstance().createUserTrip("1234", data: trip, success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - validation trip dates
     */
    func testCreateUserTripFailedValidation3() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))
        trip.startDate = trip.endDate.dateByAddingTimeInterval(1234)
        
        FirebaseRequestManager.sharedInstance().createUserTrip("1234", data: trip, success: { (json) -> Void in
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
     success test for create-delete /trips/<uid>/<tripID>
     */
    func testCreateAndDeleteUserTripSuccessful() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        let trip = Trip()
        trip.destination = ("Name", CLLocationCoordinate2D(latitude: 12, longitude: 12))
        trip.comment = "Success!"
        
        FirebaseRequestManager.sharedInstance().createUserTrip(Configuration.testUID, data: trip, success: { (json) -> Void in
            FirebaseRequestManager.sharedInstance().deleteUserTrip(Configuration.testUID, withID: json["name"].stringValue, success: { (json) -> Void in
                expectation?.fulfill()
                }, failure: { (error) -> Void in
                    expectation?.fulfill()
                    XCTFail("Must succeed")
            })
            
            expectation?.fulfill()
            }, failure: { (error) -> Void in
                expectation?.fulfill()
                XCTFail("Must succeed")
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    // MARK: delete
    
    /**
    fail test for /trips/<uid>/<tripID> - validation uid
    */
    func testDeleteUserTripFailedValidation1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().deleteUserTrip("", withID: "1234", success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - validation tripID
     */
    func testDeleteUserTripFailedValidation2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().deleteUserTrip("1234", withID: "", success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - bad UID
     */
    func testDeleteTripFailed1() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().deleteUserTrip("asdf-1234", withID: Configuration.testTripID, success: { (json) -> Void in
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
     fail test for /trips/<uid>/<tripID> - bad tripID
     */
    func testDeleteTripFailed2() {
        weak var expectation: XCTestExpectation? = expectationWithDescription(__FUNCTION__)
        FirebaseRequestManager.sharedInstance().deleteUserTrip(Configuration.testUID, withID: "asdf-1234", success: { (json) -> Void in
            expectation?.fulfill()
            XCTAssert(json.type == .Null, "Must be null")
            }, failure: { (error) -> Void in
                expectation?.fulfill()
        })
        
        waitForExpectationsWithTimeout(20) { (error) in
            XCTAssertNil(error, "\(error)")
        }
    }
}
