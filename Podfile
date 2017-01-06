platform :ios, '9.0'
use_frameworks!

target 'XianHui' do
#Objective-C
pod 'ChatKit', '0.8.5'
pod 'CTAssetsPickerController',  '~> 3.3.0'
pod 'DZNEmptyDataSet'
pod 'TWMessageBarManager'
pod 'MWPhotoBrowser'
pod 'UITextView+Placeholder', '~> 1.2'
pod 'BKPasscodeView'
pod 'UAProgressView'
pod 'EAIntroView', '~> 2.9.0'

#Swift 3.0
pod 'SwiftyJSON', :git => 'https://github.com/acegreen/SwiftyJSON.git', :branch => 'swift3'
pod 'SnapKit', '~> 3.0.0'
pod 'Alamofire','~> 4.0.0'
pod 'Kingfisher','~> 3.1.0'
pod 'Charts','~> 3.0.0'
pod 'Ruler', '~> 1.0.0'
pod 'Proposer', '~> 1.0.0'
pod 'IQKeyboardManagerSwift', '4.0.6'
pod 'RealmSwift'
pod 'SwiftDate', '~> 4.0'
pod 'ValueStepper'
pod 'CryptoSwift'
pod 'swiftScan', :git => 'https://github.com/CNKCQ/swiftScan.git', :branch => 'Swift3.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

