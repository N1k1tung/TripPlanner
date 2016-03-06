# TripPlanner 

This repo contains TripPlanner app, that allows user to schedule trips or log his past visits. Additionally it contains a test suite for Firebase REST API


## Environment Requirement

Mac OS X 10.11 or above
XCode 7.2
Runtime: iOS 8.0 or above device/simulator

## Third party code

The main app relies on following frameworks:

[Firebase](https://www.firebase.com/docs/ios/quickstart.html) - Firebase integration
[PKHUD](https://github.com/pkluz/PKHUD) - fancy HUD to display progress and errors/success events
[IQKeyboardManagerSwift](https://github.com/hackiftekhar/IQKeyboardManager) - auto scrolls active input views based on keyboard position
[KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) - keychain used to store latest credentials  to allow restoring login session

Test suite for Firebase REST API relies on:

[Alamofire](https://github.com/Alamofire/Alamofire) - NSURLSession wrapper
[SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON.git) - facilitates usage of JSON data
[ReachabilitySwift](https://github.com/ashleymills/Reachability.swift) - reachablity check

All frameworks are freely distributed (MIT licensed or similar) and are embedded using CocoaPods

## Configuration

Main app's configuration is located at TripPlanner/Configurations.plist

Configuration values are: 

*firebaseURL* - Firebase URL 

Configuration for test suite is located at FirebaseWrapper/Configuration.plist

Configuration values are: 

*logLevel* - maximum log level to output (see Logger.swift for available levels)
*firebaseAccessToken* - Firebase auth token (can be found on your Firebase App Dashboard -> Secrets)
*endpoint* - Firebase URL 

## Running

1 	Open the ‘TripPlanner.xcworkspace’ file in root folder,

2 	Choose “TripPlanner” scheme

3	Do a clean:
-	From XCode menu : Project -> Clean 
-	From Simulator menu : iOS Simulator -> Reset Contents and Settings…

4	Now run. 

## Testing

1 	Choose “FirebaseWrapper” scheme
2   You can run test suites via Test navigation panel or via the XCode menu (Product -> Test)

## Notes

The Firebase REST API is supposed to be used for server-side backend code, so there's no practical way to implement auth on client with it: [https://www.firebase.com/docs/rest/guide/user-auth.html](https://www.firebase.com/docs/rest/guide/user-auth.html). Hence I used the actual Firebase SDK for iOS to integrate with Firebase and made a separate test suite against a REST API wrapper which allows similar CRUD operations 

## Verification Steps

Please follow the provided Verification Guide.pdf