# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

source 'https://github.com/artsy/Specs.git'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/twilio/cocoapod-specs'

target 'Pepr' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Pepr
  pod 'Kanna', '~> 1.1.0'
  pod 'UberRides'
  pod 'AFNetworking', '~> 2.5'
  pod 'BDBOAuth1Manager'
  pod "YelpAPI"
  pod "SwiftSpinner"
  pod 'SCLAlertView'
  pod "DGRunkeeperSwitch", "~> 1.1"
  pod 'TwilioClient', '~>1.2'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end
end