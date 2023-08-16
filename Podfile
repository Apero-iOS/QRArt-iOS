# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'QRArtGenerator' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for QRArtGenerator

  pod 'R.swift', '7.3.2'
  pod 'IQKeyboardManagerSwift', '6.5.12'
  pod 'RealmSwift', '10.40.2'
  pod 'Alamofire', '5.7.1'
  pod 'lottie-ios', '4.2.0'
  pod 'PKHUD', '5.3.0'
#  pod 'BottomSheet', :git => 'https://github.com/weitieda/bottom-sheet.git'
  pod 'MobileAds' , :git => "https://github.com/AperoVN/MobileAds.git"
  pod 'SwCrypt'
  pod 'SkeletonUI'
  pod 'ScreenshotPreventing/SwiftUI', '1.4.0'
  pod 'ExytePopupView'
  
  target 'QRArtGeneratorTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'QRArtGeneratorUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
