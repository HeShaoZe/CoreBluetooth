#
#  Be sure to run `pod spec lint SCSGQRCode.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name         = "CoreBluetooth"
    s.version      = "0.0.2"
    s.ios.deployment_target = '8.0'
    #s.platform = :ios, '8.0'
    s.summary      = "An easy way to use CoreBluetooth scan for iOS"
    s.homepage     = "https://github.com/HeShaoZe/CoreBluetooth"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "heshaoze" => "1019067842@qq.com" }
    s.social_media_url   = "https://github.com/HeShaoZe/CoreBluetooth"
    s.source       = { :git => "https://github.com/HeShaoZe/CoreBluetooth.git", :tag => s.version }
    s.source_files  = "CoreBluetooth1104PM/Controller/*.{h,m}"
    #s.resources          = "SCSGQRCode/SCSGQRCode/SCSGQRCode.bundle"
    s.requires_arc = true
end



