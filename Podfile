# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'RoyoConsultant' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for RoyoConsultant
  pod 'Moya'                        # Networking APIs (internally using Alamofire)
  pod 'SwiftEntryKit'               # Error Alerts
  pod 'Nuke'                        # Image Caching and loading
  pod 'IQKeyboardManagerSwift'      # Keyboard textfield distance handling and Done accessory
  pod 'Socket.IO-Client-Swift'      # Chat Sockets
#  pod 'CountryList'                 # Country Picker
  pod 'SZTextView'                  # UITextView with placeholder
  pod 'lottie-ios'                  # Custom JSON Loaders
  pod 'MXParallaxHeader', '0.6.1'   # Parralax header animation with scrollviews (latest version has some issues)---Keep it 0.6.1
  pod 'HCSStarRatingView'           # Star Rating during adding review
  pod 'JVFloatLabeledTextField'     # TextField with floating placeholder
  pod 'Firebase/DynamicLinks'       # Deep Linking
  pod 'Firebase/Messaging'          # Notifications
  pod 'Firebase/Analytics'
  pod 'FSCalendar'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'JitsiMeetSDK'
  pod 'TagListView'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['ENABLE_BITCODE'] = 'NO'
          end
      end
  end
  
end
