platform :ios, ‘9.0’
use_frameworks!

target 'XianHui' do
#Objective-C
pod 'ChatKit'
pod 'CTAssetsPickerController',  '~> 3.3.0'
pod 'DZNEmptyDataSet'
pod 'TWMessageBarManager'
pod 'MWPhotoBrowser'
pod 'UITextView+Placeholder', '~> 1.2'
pod 'BKPasscodeView'
pod 'UAProgressView'
pod 'EBForeNotification'
pod 'EAIntroView', '~> 2.9.0'
pod 'EBForeNotification'


#Swift 2.3
pod 'RealmSwift', '~> 1.1.0'
pod 'Proposer', '~> 0.9.1'
pod 'SnapKit', '~> 0.22.0'
pod 'Kingfisher', '~> 2.3'
pod 'Alamofire', '~> 3.5.0'
pod 'SwiftyJSON', '2.4.0'
pod 'Charts','~> 2.3.0'
pod 'IQKeyboardManagerSwift', '4.0.5'
pod 'SwiftDate',   :git => 'https://github.com/malcommac/SwiftDate',          :branch => 'feature/swift_23'
pod 'ValueStepper',:git => 'https://github.com/BalestraPatrick/ValueStepper', :branch => 'swift-2.3'
pod 'CryptoSwift', :git => 'https://github.com/krzyzanowskim/CryptoSwift',    :branch => 'swift2'

#swift 2.0
pod 'SwiftString'
pod 'Palau', '~> 1.0'
pod 'LTInfiniteScrollView-Swift'
pod 'swiftScan'
pod 'PageMenu'
pod 'ICSPullToRefresh', '~> 0.4'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end

