# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'TripPlanner' do
    pod 'Firebase', '>= 2.5.0'
    pod 'PKHUD'
    pod 'IQKeyboardManagerSwift'
    pod 'KeychainAccess'
end

target 'TripPlannerUITests' do

end

def rest_pods
    pod 'Alamofire', '~> 3.0'
    pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
    pod 'ReachabilitySwift', :git => 'https://github.com/ashleymills/Reachability.swift'
end

target 'FirebaseWrapper' do
    rest_pods
end

target 'FirebaseWrapperTests' do
    rest_pods
end